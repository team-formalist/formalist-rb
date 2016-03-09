require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class TextField < Field
      attribute :password, Types::Bool
    end

    register :text_field, TextField
  end
end
