require_relative 'application_service'
require 'net/http'

# this service is used for any web-application if there is no special service to
# work with this application
class BitbucketService < ApplicationService
  def pull
    print 'Testing service Bitbucket... ' unless @silent
    result = check
    ok_or_fail result unless @silent

    {
      name: 'Bitbucket',
      status: result ? 'up' : 'down',
      date: Time.now
    }
  end

  private

  def check
    response = Net::HTTP.get_response(URI('https://bitbucket.status.atlassian.com/'))
    response
      .body
      .scan(/(<span\s*class=\s*\"component\-status\s*\".*\n?.*\n?.*>)(\n.*)/)
      .map { |line| line[1].strip == 'Operational' }
      .reduce { |a, b| a && b }
  rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
         Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,
         SocketError
    false
  end
end
