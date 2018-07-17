require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class DateTimeField < Field
      attribute :time_format, Types::String
      attribute :human_time_format, Types::String
    end

    register :date_time_field, DateTimeField
  end
end
