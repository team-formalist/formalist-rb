require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class RichTextArea < Field
      attribute :box_size, Types::String.enum("single", "small", "normal", "large", "xlarge"), default: "normal"
      attribute :inline_formatters, Types::Array
      attribute :block_formatters, Types::Array
      attribute :embeddable_forms, Types::Strict::Hash # TODO: need better typing, perhaps even require a rich object rather than a hash

      # FIXME: it would be tidier to have a reader method for each attribute
      def attributes
        attrs = super

        # Replace the form objects with their AST
        attrs.merge(
          embeddable_forms: Hash(attrs[:embeddable_forms]).map { |key, attrs|
            original_attrs = attrs
            adjusted_attrs = original_attrs.merge(form: original_attrs[:form].build.to_ast)

            [key, adjusted_attrs]
          }.to_h
        )
      end
    end

    register :rich_text_area, RichTextArea
  end
end
