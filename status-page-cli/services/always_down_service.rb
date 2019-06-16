require_relative 'application_service'

# this service is used for any web-application if there is no special service to
# work with this application
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
