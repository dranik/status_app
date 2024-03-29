#!/usr/bin/env ruby
require 'colorize'
require 'thor'
require 'yaml'
require 'terminal-table'
require 'fileutils'
require_relative 'services/default_service'
require_relative 'helpers'
require_relative 'storage/database'
require_relative 'storage/json'

CONFIG = YAML.load_file('config/config.yml')
SQL = CONFIG['sql']
TITLE = 'CLI service status tool'.freeze
DB = (SQL ? Database : Json).new
p SQL

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
      DB.insert entry unless options['nosave']
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

  option :status, type: :string
  option :service, type: :string
  desc 'history', 'show historical data'

  def history
    params = {}
    params[:status] = options['status'] if options['status']
    params[:name] = options['service'] if options['service']
    collection = DB.where(params)
    table = Terminal::Table.new do |t|
      t << %w[Service State Time]
      t << :separator
      collection.each do |entry|
        t.add_row [entry[:name], entry[:status] == 'up' ? entry[:status].green : entry[:status].red, entry[:date]]
      end
    end
    puts table
  end

  desc 'backup PATH', 'copy gathered data'

  def backup(path)
    FileUtils.cp(DB.filename, path)
    puts "Database copied to #{path}".blue
  end

  option :drop, type: :boolean, default: false
  desc 'restore PATH', 'restore data from another copy of db'

  def restore(path)
    db2 = (SQL ? Database : Json).new(path)
    collection = db2.all
    DB.drop if options['drop']
    collection.each do |entry|
      DB.insert(entry.reject { |key, _value| key == :id })
    end
  end
end

CLI.start(ARGV)
