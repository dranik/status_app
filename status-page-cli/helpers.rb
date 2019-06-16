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
end
