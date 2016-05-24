require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class UploadField < Field
      attribute :presign_url, Types::String
      attribute :render_uploaded_as, Types::String
      attribute :upload_prompt, Types::String
      attribute :upload_action_label, Types::String
    end

    register :upload_field, UploadField
  end
end
