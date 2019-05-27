require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class SelectionField < Field
      attribute :options
      attribute :selector_label
      attribute :render_option_as
      attribute :render_selection_as
    end

    register :selection_field, SelectionField
  end
end
