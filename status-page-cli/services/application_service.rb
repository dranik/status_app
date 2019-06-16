# prototype for any service object
class ApplicationService
  def initialize(silent, service)
    @silent = silent
    @service = service
  end

  def pull
    raise NotImplementedError
  end
end
