require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class TextArea < Field
      attribute :text_size, Types::String.enum("xsmall", "small", "normal", "large", "xlarge"), default: "normal"
      attribute :box_size, Types::String.enum("single", "small", "normal", "large", "xlarge"), default: "normal"
      attribute :code Types::Bool
    end

    register :text_area, TextArea
  end
end
