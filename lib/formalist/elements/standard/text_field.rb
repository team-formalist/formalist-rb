require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class TextField < Field
      attribute :password
      attribute :code
      attribute :disabled
    end

    register :text_field, TextField
  end
end
