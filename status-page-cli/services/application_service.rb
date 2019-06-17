require_relative 'helpers/service_helpers'

# prototype for any service object
class ApplicationService
  include ServiceHelpers
  def initialize(silent, service)
    @silent = silent
    @service = service
  end

  def pull
    raise NotImplementedError
  end
end
