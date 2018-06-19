require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class SearchSelectionField < Field
      attribute :selector_label, Types::String
      attribute :render_option_as, Types::String
      attribute :render_option_control_as, Types::String
      attribute :render_selection_as, Types::String
      attribute :search_url, Types::String
      attribute :search_per_page, Types::Int
      attribute :search_params, Types::Hash
      attribute :search_threshold, Types::Int
      attribute :selection, Types::Hash
    end

    register :search_selection_field, SearchSelectionField
  end
end
