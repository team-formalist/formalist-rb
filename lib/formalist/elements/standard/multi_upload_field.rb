require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class MultiUploadField < Field
      attribute :presign_url, Types::String
    end

    register :multi_upload_field, MultiUploadField
  end
end
