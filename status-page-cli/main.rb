require 'colorize'
require 'thor'
require 'yaml'
require_relative 'services/default_service'
require_relative 'helpers'
require_relative 'database'

CONFIG = YAML.load_file('config/config.yml')
TITLE = 'CLI service status tool'.freeze
DB = Database.new

# cli controller
class CLI < Thor
  include Helpers

  option :nosave, type: :boolean
  option :nodisplay, type: :boolean
  option :only
  option :except
  desc 'pull', 'pull data'

  def pull
    p options
    system('clear') || system('cls') unless options['nodisplay']
    puts "#{TITLE}\nPulling data from servers..." unless options['nodisplay']
    services = CONFIG['services']
    services.each do |_key, service|
      klass = define_implementation(service)
      entry = klass.new(options['nodisplay'], service).pull
      DB.entries.insert entry unless options['nosave']
    end
  end
end

CLI.start(ARGV)
