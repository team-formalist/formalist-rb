require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class TagsField < Field
      attribute :search_url
      attribute :search_per_page
      attribute :search_params
      attribute :search_threshold
    end

    register :tags_field, TagsField
  end
end
