module Helpers
  def get_class(snake_string)
    Object.const_get(snake_string.split('_').map(&:capitalize).join)
  end

  def define_implementation(service)
    return DefaultService unless service['implementation']

    require_relative "services/#{service['implementation']}_service"
    get_class("#{service['implementation']}_service")
  rescue LoadError, NameError
    puts "Service #{service['name']} has no implementation, trying default".yellow
    DefaultService
  end

  def filter_services(services, options)
    only = options['only'] || services.keys
    except = options['except'] || []
    services
      .select { |key, value| only.member?(key) || only.member?(value['name']) }
      .select { |key, value| !(except.member?(key) || except.member?(value['name'])) }
  end
end
