require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class UploadField < Field
      attribute :initial_attributes_url
      attribute :presign_url
      attribute :presign_options
      attribute :render_uploaded_as
      attribute :upload_prompt
      attribute :upload_action_label
      attribute :max_file_size
      attribute :max_file_size_message
      attribute :permitted_file_type_message
      attribute :permitted_file_type_regex
    end

    register :upload_field, UploadField
  end
end
