module HerokuLog
  class Page
    def initialize
      @services = collect_status
    end

    def render
      ERB.new(TEMPLATE).result(binding)
    end

    private

    def collect_status
      CONFIG['services'].map { |s| find_status(s[1]) }
    end

    def find_status(service)
      count = redis.keys("#{service['type']}*").count
      current = (count == 0 ? :down : (count < service['warning'] ? :warning : :running))
      service.merge(get_colors(current))
    end

    def get_colors(status)
      case status
      when :down
        { 'status' => :down, 'color' => 'red', 'icon' => 'error' }
      when :warning
        { 'status' => :warning, 'color' => 'orange', 'icon' => 'remove_circle' }
      when :running
        { 'status' => :running, 'color' => 'green', 'icon' => 'check_circle' }
      end
    end

    def redis
      Redis.current
    end
  end
end
