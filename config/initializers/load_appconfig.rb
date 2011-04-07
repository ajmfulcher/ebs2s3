require 'rubygems'
require 'yaml'

# Get application configuration
APP_CONFIG = YAML::load(File.open("#{RAILS_ROOT}/config/appconfig.yml"))
