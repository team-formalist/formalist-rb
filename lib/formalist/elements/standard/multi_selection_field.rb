require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class MultiSelectionField < Field
      attribute :sortable
      attribute :max_height
      attribute :options
      attribute :render_option_as
      attribute :render_selection_as
      attribute :selector_label
    end

    register :multi_selection_field, MultiSelectionField
  end
end
