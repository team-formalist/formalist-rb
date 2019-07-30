require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class RadioButtons < Field
      attribute :options
    end

    register :radio_buttons, RadioButtons
  end
end
