require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class RadioButtons < Field
      attribute :options, Types::OptionsList
    end

    register :radio_buttons, RadioButtons
  end
end
