require_relative 'application_service'
require 'net/http'

# this service is used for any web-application if there is no special service to
# work with this application
class DefaultService < ApplicationService
  def pull
    print "Testing service #{@service['name']}... " unless @silent
    hosts = @service['options']['host'] unless @silent
    hosts = hosts.class == Array ? hosts : [hosts]
    result = hosts
             .map { |host| check host }
             .reduce { |a, b| @service['options']['policy'] == 'all' ? a && b : a || b }
    ok_or_fail result unless @silent

    {
      service: @service['name'],
      status: result ? 'up' : 'down',
      time: Time.now
    }
  end

  private

  def check(host)
    Net::HTTP.get(host, '/')
    true
  rescue
    false
  end

  def ok_or_fail(flag)
    if flag
      puts 'OK!'.green
    else
      puts 'Fail'.red
    end
  end
end
