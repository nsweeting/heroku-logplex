module HerokuLog
  class Auth < Rack::Auth::Basic
    def call(env)
      req = Rack::Request.new(env)
      if req.path == '/logger'
        super
      else
        @app.call(env)
      end
    end
  end
end
