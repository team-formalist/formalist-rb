require "formalist/element"

module Formalist
  class Elements
    class Attr < Element
      attribute :label

      def fill(input:, errors:)
        input = input[name] || {}
        errors = errors[name] || {}

        children = self.children.map { |child|
          child.fill(input: input, errors: errors)
        }

        super(input: input, errors: errors, children: children)
      end

      # Converts the attribute into an abstract syntax tree.
      #
      # It takes the following format:
      #
      # ```
      # [:attr, [params]]
      # ```
      #
      # With the following parameters:
      #
      # 1. Attribute name
      # 2. Custom element type (or `:attr` otherwise)
      # 3. Error messages
      # 4. Form element attributes
      # 5. Child form elements
      #
      # @see Formalist::Element::Attributes#to_ast "Form element attributes" structure
      #
      # @example "metadata" attr
      #   attr.to_ast
      #   # => [:attr, [
      #     :metadata,
      #     :attr,
      #     ["metadata is missing"],
      #     [:object, []],
      #     [...child elements...]
      #   ]]
      #
      # @return [Array] the attribute as an abstract syntax tree.
      def to_ast
        local_errors = errors.is_a?(Array) ? errors : []

        [:attr, [
          name,
          type,
          local_errors,
          Element::Attributes.new(attributes).to_ast,
          children.map(&:to_ast),
        ]]
      end
    end
  end
end
