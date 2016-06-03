module HerokuLog
  class Logger
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)
      return [204, {}, nil] if call_logger?(req, env['HTTP_LOGPLEX_DRAIN_TOKEN'])
      @app.call(env)
    end

    private

    def call_logger?(req, drain_token)
      return false unless req.path == '/logger' && drain_token == DRAIN_TOKEN
      thread = Thread.new { HerokuLog::Parser.new(req.params).call }
      thread.join
      true
    end
  end
end
