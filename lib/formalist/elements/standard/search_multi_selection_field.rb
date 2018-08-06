require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class SearchMultiSelectionField < Field
      attribute :clear_query_on_selection, Types::Bool
      attribute :sortable, Types::Bool
      attribute :max_height, Types::String
      attribute :render_option_as, Types::String
      attribute :render_option_control_as, Types::String
      attribute :render_selection_as, Types::String
      attribute :search_params, Types::Hash
      attribute :search_per_page, Types::Integer
      attribute :search_threshold, Types::Integer
      attribute :search_url, Types::String
      attribute :selections, Types::Array
      attribute :selector_label, Types::String
    end

    register :search_multi_selection_field, SearchMultiSelectionField
  end
end
