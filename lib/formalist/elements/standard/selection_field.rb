require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class SelectionField < Field
      attribute :options, Types::SelectionsList
      attribute :selector_label, Types::String
      attribute :render_option_as, Types::String
      attribute :render_selection_as, Types::String
    end

    register :selection_field, SelectionField
  end
end
