require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class DateField < Field
    end

    register :date_field, DateField
  end
end
