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
  option :only, type: :array
  option :except, type: :array
  desc 'pull', 'pull data from the specified sources'

  def pull
    system('clear') || system('cls') unless options['nodisplay']
    puts "#{TITLE}\nPulling data from servers..." unless options['nodisplay']
    services = filter_services(CONFIG['services'], options)
    services.each do |_key, service|
      klass = define_implementation(service)
      entry = klass.new(options['nodisplay'], service).pull
      DB.entries.insert entry unless options['nosave']
    end
  end

  option :nosave, type: :boolean
  option :nodisplay, type: :boolean
  option :only, type: :array
  option :except, type: :array
  option :refresh, type: :numeric, default: 2
  desc 'live', 'pull data from the specified sources with pre-set refresh rate'

  def live
    while true
      pull
      sleep options['refresh']
    end
  end

  option :except, type: :array
  option :only, type: :array
  desc 'history', 'show historical data'

  def history
    p DB.entries.all
  end


end

CLI.start(ARGV)
