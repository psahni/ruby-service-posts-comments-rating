require 'yaml'
require 'pg'
require 'active_record'

Dir.glob('./src/**/*.rb').each do |file|
  require file
end

env = 'development'

db_config_file = File.open('db/database.yml')
db_config = YAML::load(db_config_file)


puts "==> Estabalish DB Connection"
ActiveRecord::Base.establish_connection(db_config[env])
