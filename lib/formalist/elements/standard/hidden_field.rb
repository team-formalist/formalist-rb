require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class HiddenField < Field
    end

    register :hidden_field, HiddenField
  end
end
