require "formalist/element"
require "formalist/types"

module Formalist
  class Elements
    class Component < Element
      permitted_children :field

      # Converts the component into an abstract syntax tree.
      #
      # It takes the following format:
      #
      # ```
      # [:component, [params]]
      # ```
      #
      # With the following parameters:
      #
      # 1. Section name
      # 2. Custom element type (or `:component` otherwise)
      # 3. Form element attributes
      # 4. Child form elements
      #
      # @see Formalist::Element::Attributes#to_ast "Form element attributes" structure
      #
      # @example
      #   component.to_ast
      #   # => [:component, [
      #     :content,
      #     :component,
      #     [:object, []],
      #     [...child elements...],
      #   ]]
      #
      # @return [Array] the component as an abstract syntax tree.
      def to_ast
        [:component, [
          type,
          Element::Attributes.new(attributes).to_ast,
          children.map(&:to_ast),
        ]]
      end
    end
  end
end
