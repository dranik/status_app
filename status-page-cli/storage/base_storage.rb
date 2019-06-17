require 'json'
# implementation for json storage
class BaseStorage
  def initialize(file = 'default.json')
    @filename = file
  end

  def insert(entry)
    raise NotImplementedError
  end
  
  def drop
    raise NotImplementedError
  end

  def where(params = {})
    raise NotImplementedError
  end

  def all
    raise NotImplementedError
  end

  def filename
    @filename
  end
end
