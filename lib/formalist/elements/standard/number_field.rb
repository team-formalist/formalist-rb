require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class NumberField < Field
      attribute :step
      attribute :min
      attribute :max
    end

    register :number_field, NumberField
  end
end
