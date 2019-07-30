require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class SearchMultiSelectionField < Field
      attribute :clear_query_on_selection
      attribute :sortable
      attribute :max_height
      attribute :render_option_as
      attribute :render_option_control_as
      attribute :render_selection_as
      attribute :search_params
      attribute :search_per_page
      attribute :search_threshold
      attribute :search_url
      attribute :selections
      attribute :selector_label
    end

    register :search_multi_selection_field, SearchMultiSelectionField
  end
end
