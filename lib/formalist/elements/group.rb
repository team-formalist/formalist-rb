require "formalist/element"
require "formalist/types"

module Formalist
  class Elements
    class Group < Element
      permitted_children :attr, :compound_field, :field, :many

      attribute :label, Types::ElementString

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
          Element::Attributes.new(attributes).to_ast,
          children.map(&:to_ast),
        ]]
      end
    end
  end
end
