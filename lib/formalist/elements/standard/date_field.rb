require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class DateField < Field
    end

    register :date_field, DateField
  end
end
