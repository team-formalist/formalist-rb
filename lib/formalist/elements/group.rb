require "formalist/element"

module Formalist
  class Elements
    class Group < Element
      attribute :label

      def fill(input: {}, errors: {}, meta: {})
        children = self.children.map { |child|
          child.fill(input: input, errors: errors, meta: meta)
        }

        super(input: input, errors: errors, meta: meta, children: children)
      end

      # Converts the group into an abstract syntax tree.
      #
      # It takes the following format:
      #
      # ```
      # [:group, [params]]
      # ```
      #
      # With the following parameters:
      #
      # 1. Custom form element type (or `:group` otherwise)
      # 2. Form element attributes
      # 3. Child form elements
      #
      # @see Formalist::Element::Attributes#to_ast "Form element attributes" structure
      #
      # @example
      #   group.to_ast
      #   # => [:group, [
      #     :group,
      #     [:object, []],
      #     [...child elements...]
      #   ]]
      #
      # @return [Array] the group as an abstract syntax tree.
      def to_ast
        [:group, [
          type,
          Element::Attributes.new(attributes, meta: meta).to_ast,
          children.map(&:to_ast),
        ]]
      end
    end
  end
end
