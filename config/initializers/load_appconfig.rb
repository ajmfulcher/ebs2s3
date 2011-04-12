require 'rubygems'
require 'yaml'

# Get application configuration
APP_CONFIG = YAML::load(File.open("#{::Rails.root.to_s}/config/appconfig.yml"))
