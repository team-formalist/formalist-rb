require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class NumberField < Element
      Number = Types::Int | Types::Float

      attribute :step, Number
      attribute :min, Number
      attribute :max, Number
    end

    register :number_field, NumberField
  end
end
