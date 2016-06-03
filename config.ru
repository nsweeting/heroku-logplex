Dir["./lib/*.rb"].each { |file| require file }
require 'redis'
require 'thread'
require 'yaml'
require 'erb'

DRAIN_TOKEN = ENV['LOGPLEX_DRAIN_TOKEN']
CONFIG = YAML.load_file('config/application.yml')
TEMPLATE = File.read(File.expand_path("lib/views/index.erb"))

Redis.current = Redis.new(url: ENV['REDIS_URL'])

Rack::Request::FORM_DATA_MEDIA_TYPES << 'application/logplex-1'

use HerokuLog::Auth, 'Restricted' do |username, password|
  [username, password] == ['username', 'password']
end
use HerokuLog::Logger
run HerokuLog::Server
