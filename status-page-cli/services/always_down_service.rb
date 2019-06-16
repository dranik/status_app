require_relative 'application_service'

# this a sample of a custom implemented server
# this one is dumb but it gives a general idea how to write a custom implementation
class AlwaysDownService < ApplicationService
  def pull
    puts "Service #{@service['name']} is always down".red unless @silent

    {
      name: @service['name'],
      status: 'down',
      date: Time.now
    }
  end
end
