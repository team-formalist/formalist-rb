require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class SearchSelectionField < Field
      attribute :selector_label
      attribute :render_option_as
      attribute :render_option_control_as
      attribute :render_selection_as
      attribute :search_url
      attribute :search_per_page
      attribute :search_params
      attribute :search_threshold
      attribute :selection
    end

    register :search_selection_field, SearchSelectionField
  end
end
