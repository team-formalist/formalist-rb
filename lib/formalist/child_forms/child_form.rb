require "formalist/element"
require "formalist/elements/form_field"

module Formalist
  module ChildForms
    class ChildForm < Elements::FormField
      def to_ast
        [:child_form, [
          name,
          type,
          input,
          Element::Attributes.new(attributes).to_ast,
        ]]
      end
    end
  end
end
