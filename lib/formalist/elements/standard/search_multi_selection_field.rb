require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class SearchMultiSelectionField < Field
      attribute :selector_label, Types::String
      attribute :render_option_as, Types::String
      attribute :render_option_control_as, Types::String
      attribute :render_selection_as, Types::String
      attribute :search_url, Types::String
      attribute :search_per_page, Types::Integer
      attribute :search_params, Types::Hash
      attribute :search_threshold, Types::Integer
      attribute :selections, Types::Array
    end

    register :search_multi_selection_field, SearchMultiSelectionField
  end
end
