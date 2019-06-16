module Helpers
  def get_class(snake_string)
    Object.const_get(snake_string.split('_').map(&:capitalize).join)
  end
end
