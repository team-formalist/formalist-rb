require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class RichTextArea < Field
      attribute :box_size, Types::String.enum("single", "small", "normal", "large", "xlarge"), default: "normal"
      attribute :inline_formatters, Types::Array
      attribute :block_formatters, Types::Array
      attribute :embeddable_forms, Types::Hash
    end

    register :rich_text_area, RichTextArea
  end
end
