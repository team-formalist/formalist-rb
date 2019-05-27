require "formalist/element"

module Formalist
  class Elements
    class CompoundField < Element
      def fill(input: {}, errors: {})
        children = self.children.map { |child|
          child.fill(input: input, errors: errors)
        }

        super(input: input, errors: errors, children: children)
      end

      # Converts the compound field into an abstract syntax tree.
      #
      # It takes the following format:
      #
      # ```
      # [:compound_field, [params]]
      # ```
      #
      # With the following parameters:
      #
      # 1. Custom element type (or `:compound_field` otherwise)
      # 2. Form element attributes
      # 3. Child form elements
      #
      # @see Formalist::Element::Attributes#to_ast "Form element attributes" structure
      #
      # @example
      #   compound_field.to_ast
      #   # => [:compound_field, [
      #     :content,
      #     :compound_field,
      #     [:object, []],
      #     [...child elements...],
      #   ]]
      #
      # @return [Array] the compound field as an abstract syntax tree.
      def to_ast
        [:compound_field, [
          type,
          Element::Attributes.new(attributes).to_ast,
          children.map(&:to_ast),
        ]]
      end
    end
  end
end
