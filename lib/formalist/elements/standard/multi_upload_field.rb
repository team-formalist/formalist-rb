require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class MultiUploadField < Field
      attribute :initial_attributes_url
      attribute :sortable
      attribute :max_file_size_message
      attribute :max_file_size
      attribute :max_height
      attribute :permitted_file_type_message
      attribute :permitted_file_type_regex
      attribute :presign_options
      attribute :presign_url
      attribute :render_uploaded_as
      attribute :upload_action_label
      attribute :upload_prompt
    end

    register :multi_upload_field, MultiUploadField
  end
end
