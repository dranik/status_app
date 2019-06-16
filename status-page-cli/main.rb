require 'colorize'
require 'thor'
require 'yaml'
require_relative 'services/default_service'
require_relative 'helpers'

CONFIG = YAML.load_file('config/config.yml')
TITLE = 'CLI service status tool'.freeze

class CLI < Thor
  include Helpers

  option :nosave, type: :boolean
  option :nodisplay, type: :boolean
  option :only
  option :except
  desc 'pull', 'pull data'

  def pull
    system('clear') || system('cls') unless options['nodisplay']
    puts "#{TITLE}\nPulling data from servers..." unless options['nodisplay']
    services = CONFIG['services']
    services.each do |key, service|
      klass = if service['implementation']
        begin
          implementation = service['implementation']
          require_relative "services/#{service['implementation']}_service"
          get_class("#{service['implementation']}_service")
        rescue LoadError, NameError
          puts "Service #{service['name']} has no implementation, trying default".yellow
          DefaultService
        end
      else
        DefaultService
      end
      klass.new(options['nodisplay'], service).pull
    end
  end
end

CLI.start(ARGV)
