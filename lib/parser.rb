module HerokuLog
  class Parser
    def initialize(params)
      @log_data = params.keys.first
    end

    def call
      return if service_key.nil?
      create_service_key
    end

    private

    attr_reader :log_data

    def service_key
      @service_key ||= CONFIG['services'].map { |s| find_key(s[1]['type']) || next }.select { |s| s }.first
    end

    def find_key(type)
      key_name = log_data[/#{Regexp.escape("#{type}")}(.*?)#{Regexp.escape(' - source')}/m, 1]
      key_name ? "#{type}#{key_name}" : false
    end

    def create_service_key
      redis.setex(service_key, 120, true)
    end

    def redis
      Redis.current
    end
  end
end
