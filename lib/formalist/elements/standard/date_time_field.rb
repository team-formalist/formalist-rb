require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class DateTimeField < Field
    end

    register :date_time_field, DateTimeField
  end
end
