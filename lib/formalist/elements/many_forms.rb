require "formalist/element"
require "formalist/child_forms/compiler"


module Formalist
  class Elements
    class ManyForms < Element
      attribute :action_label
      attribute :sortable
      attribute :label
      attribute :max_height
      attribute :placeholder
      attribute :embeddable_forms
      attribute :validation
      attribute :allow_create, default: true
      attribute :allow_update, default: true
      attribute :allow_destroy, default: true
      attribute :allow_reorder, default: true

      # FIXME: it would be tidier to have a reader method for each attribute
      def attributes
        super.merge(embeddable_forms: embeddable_forms_ast)
      end

       # @api private
       def fill(input: {}, errors: {})
        input = input.fetch(name) { [] }
        errors = errors.fetch(name) { {} }

        super(
          input: input,
          errors: errors,
          children: form_compiler.(input),
        )
      end

      # Replace the form objects with their AST
      def embeddable_forms_ast
        @attributes[:embeddable_forms].to_h.map { |key, attrs|
          [key, attrs.merge(form: attrs[:form].to_ast)]
        }.to_h
      end

      def form_compiler
        ChildForms::Compiler.new(@attributes[:embeddable_forms])
      end

      # Converts a collection of "many" repeating elements into an abstract
      # syntax tree.
      #
      # It takes the following format:
      #
      # ```
      # [:many, [params]]
      # ```
      #
      # With the following parameters:
      #
      # 1. Collection name
      # 2. Custom form element type (or `:many` otherwise)
      # 3. Collection-level error messages
      # 4. Form element attributes
      # 6. Child elements, one for each of the entries in the input data (or
      #    none, if there is no or empty input data)
      #
      # @see Formalist::Element::Attributes#to_ast "Form element attributes" structure
      #
      # @example "components" collection
      #   many.to_ast
      #   # => [:many_forms, [
      #     :locations,
      #     :many_forms,
      #     ["components size cannot be less than 3"],
      #     [:object, [
      #       [:allow_create, [:value, [true]]],
      #       [:allow_update, [:value, [true]]],
      #       [:allow_destroy, [:value, [true]]],
      #       [:allow_reorder, [:value, [true]]]
      #     ]],
      #     [
      #       [
                # {:name => "image_with_caption",
                #   :label => "Image with caption",
                #   :data => {"image_id" => "", "caption" => "Large panda"},
                #   :form => [[:field, [:image_id, :text_field, "", ["must be filled"], [:object, []]]], [:field, [:caption, :text_field, "Large panda", [], [:object, []]]]]
                # }
      #     ]
      #   ]]
      #
      # @return [Array] the collection as an abstract syntax tree.
      def to_ast
        local_errors = errors.is_a?(Array) ? errors : []

        [:many_forms, [
          name,
          type,
          local_errors,
          Element::Attributes.new(attributes).to_ast,
          children
        ]]
      end
    end
  end
end
