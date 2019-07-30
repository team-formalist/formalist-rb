require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class TextArea < Field
      attribute :text_size, default: "normal"
      attribute :box_size, default: "normal"
      attribute :code
    end

    register :text_area, TextArea
  end
end
