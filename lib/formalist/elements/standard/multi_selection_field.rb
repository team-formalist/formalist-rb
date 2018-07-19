require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class MultiSelectionField < Field
      attribute :sortable, Types::Bool
      attribute :max_height, Types::String
      attribute :options, Types::SelectionsList
      attribute :render_option_as, Types::String
      attribute :render_selection_as, Types::String
      attribute :selector_label, Types::String
    end

    register :multi_selection_field, MultiSelectionField
  end
end
