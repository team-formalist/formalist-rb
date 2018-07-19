require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class MultiUploadField < Field
      attribute :sortable, Types::Bool
      attribute :max_file_size_message, Types::String
      attribute :max_file_size, Types::String
      attribute :max_height, Types::String
      attribute :permitted_file_type_message, Types::String
      attribute :permitted_file_type_regex, Types::String
      attribute :presign_options, Types::Hash
      attribute :presign_url, Types::String
      attribute :render_uploaded_as, Types::String
      attribute :upload_action_label, Types::String
      attribute :upload_prompt, Types::String
    end

    register :multi_upload_field, MultiUploadField
  end
end
