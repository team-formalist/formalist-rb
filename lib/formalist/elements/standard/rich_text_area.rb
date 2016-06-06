require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class RichTextArea < Field
      attribute :box_size, Types::String.enum("single", "small", "normal", "large", "xlarge"), default: "normal"
      attribute :inline_formatters, Types::Array
    end

    register :rich_text_area, RichTextArea
  end
end
