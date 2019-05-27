require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class SelectBox < Field
      attribute :options
    end

    register :select_box, SelectBox
  end
end
