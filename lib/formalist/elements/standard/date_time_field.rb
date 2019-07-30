require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class DateTimeField < Field
      attribute :time_format
      attribute :human_time_format
    end

    register :date_time_field, DateTimeField
  end
end
