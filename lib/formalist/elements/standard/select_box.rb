require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class SelectBox < Field
      attribute :options, Types::OptionsList
    end

    register :select_box, SelectBox
  end
end
