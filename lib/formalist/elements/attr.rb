require "formalist/element"
require "formalist/types"

module Formalist
  class Elements
    class Attr < Element
      permitted_children :all

      # @api private
      attr_reader :name

      # @api private
      def initialize(*args, attributes, children, input, errors)
        super

        @name = Types::ElementName.(args.first)
        @input = input.fetch(@name, {})
        @errors = errors[@name]
        @children = build_children(children)
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

      private

      def build_children(definitions)
        child_errors = errors.is_a?(Hash) ? errors : {}

        definitions.map { |definition| definition.(input, child_errors) }
      end
    end
  end
end
