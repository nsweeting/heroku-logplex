module HerokuLog
  class Server
    def self.call(env)
      req = Rack::Request.new(env)
      res = Rack::Response.new
      case req.path
      when '/favicon.ico'
        res.write('')
      else
        res.write(HerokuLog::Page.new.render)
      end
      res.finish
    end
  end
end
