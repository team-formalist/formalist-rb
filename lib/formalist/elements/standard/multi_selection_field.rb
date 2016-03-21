require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class MultiSelectionField < Field
      attribute :options, Types::SelectionsList
      attribute :select_button_text, Types::String
      attribute :selected_component, Types::String
      attribute :selection_component, Types::String
    end

    register :multi_selection_field, MultiSelectionField
  end
end
