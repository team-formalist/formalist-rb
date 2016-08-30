require "formalist/element"
require "formalist/elements"
require "formalist/types"
require "formalist/rich_text/embedded_form_compiler"

module Formalist
  class Elements
    class RichTextArea < Field
      attribute :box_size, Types::String.enum("single", "small", "normal", "large", "xlarge"), default: "normal"
      attribute :inline_formatters, Types::Array
      attribute :block_formatters, Types::Array
      attribute :embeddable_forms, Types::Dependency.constrained(respond_to: :to_h)

      # FIXME: it would be tidier to have a reader method for each attribute
      def attributes
        # Replace the form objects with their AST
        super.merge(embeddable_forms: embeddable_forms_config)
      end

      def embeddable_forms_config
        Hash(@attributes[:embeddable_forms].to_h).map { |key, attrs|
          original_attrs = attrs
          adjusted_attrs = original_attrs.merge(form: original_attrs[:form].build.to_ast)

          [key, adjusted_attrs]
        }.to_h
      end

      def input
        input_compiler.(@input)
      end

      private

      def input_compiler
        RichText::EmbeddedFormCompiler.new(@attributes[:embeddable_forms])
      end
    end

    register :rich_text_area, RichTextArea
  end
end
