require "formalist/element"

module Formalist
  class Elements
    class Section < Element
      attribute :label

      def fill(input: {}, errors: {}, meta: {})
        super(
          input: input,
          errors: errors,
          meta: meta,
          children: children.map { |child| child.fill(input: input, errors: errors, meta: meta) },
        )
      end

      # Converts the section into an abstract syntax tree.
      #
      # It takes the following format:
      #
      # ```
      # [:section, [params]]
      # ```
      #
      # With the following parameters:
      #
      # 1. Section name
      # 2. Custom form element type (or `:section` otherwise)
      # 3. Form element attributes
      # 4. Child form elements
      #
      # @see Formalist::Element::Attributes#to_ast "Form element attributes" structure
      #
      # @example "content" section
      #   section.to_ast
      #   # => [:section, [
      #     :content,
      #     :section,
      #     [:object, []],
      #     [...child elements...]
      #   ]]
      #
      # @return [Array] the section as an abstract syntax tree.
      def to_ast
        [:section, [
          name,
          type,
          Element::Attributes.new(attributes, meta: meta).to_ast,
          children.map(&:to_ast),
        ]]
      end
    end
  end
end
