require_relative 'application_service'
require 'net/http'

# this service is used for any web-application if there is no special service to
# work with this application
class DefaultService < ApplicationService
  def pull
    print "Testing service #{@service['name']}... " unless @silent
    hosts = @service['options']['host']
    hosts = hosts.class == Array ? hosts : [hosts]
    result = hosts
             .map { |host| check host }
             .reduce { |a, b| @service['options']['policy'] == 'all' ? a && b : a || b }
    ok_or_fail result unless @silent

    {
      name: @service['name'],
      status: result ? 'up' : 'down',
      date: Time.now
    }
  end

  private

  def check(host)
    response = Net::HTTP.get_response(host, '/')
    [200, 301, 302].member?(response.code.to_i)
  rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
         Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,
         SocketError
    false
  end
end
