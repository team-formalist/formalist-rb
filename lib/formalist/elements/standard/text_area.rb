require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class TextArea < Field
      attribute :text_size, Types::String.enum("xsmall", "small", "normal", "large", "xlarge").default("standard")
      attribute :box_size, Types::String.enum("single", "small", "normal", "large", "xlarge").default("standard")
    end

    register :text_area, TextArea
  end
end
