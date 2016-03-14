require "formalist/element"
require "formalist/types"

module Formalist
  class Elements
    class Attr < Element
      permitted_children :all

      # @api private
      attr_reader :name

      # @api private
      attr_reader :child_errors

      # @api private
      def initialize(*args, attributes, children, input, errors)
        super

        @name = Types::ElementName.(args.first)
        @input = input.fetch(name, {})
        @errors = errors.fetch(name, [])[0] || []
        @child_errors = errors[0].is_a?(Hash) ? errors[0] : {}
      end

      # @api private
      def build_child(definition)
        definition.(input, child_errors)
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
      # 3. Validation error messages (if any)
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
        # Errors, if the attr hash is present and its members have errors:
        # {:meta=>[[{:pages=>[["pages is missing"], nil]}], {}]}

        # Errors, if the attr hash hasn't been provided
        # {:meta=>[["meta is missing"], nil]}

        local_errors = errors[0].is_a?(Hash) ? [] : errors

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
