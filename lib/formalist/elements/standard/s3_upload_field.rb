require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class S3UploadField < Field
      attribute :presign_url, Types::String
    end

    register :s3_upload_field, S3UploadField
  end
end
