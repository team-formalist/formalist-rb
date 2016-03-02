require "formalist/element"
require "formalist/types"

module Formalist
  class Elements
    class Group < Element
      permitted_children :attr, :component, :field, :many

      # Converts the group into an array format for including in a form's
      # abstract syntax tree.
      #
      # The array takes the following format:
      #
      # ```
      # [:group, [params]]
      # ```
      #
      # With the following parameters:
      #
      # 1. Group configuration
      # 1. Child form elements
      #
      # @example
      #   group.to_ast # =>
      #   # [:group, [
      #   #   [
      #   #     [:some_config_name, :some_config_value]
      #   #   ],
      #   #   [
      #   #     ...child elements...
      #   #   ]
      #   # ]]
      #
      # @return [Array] the group as an array.
      def to_ast
        [:group, [
          type,
          attributes.to_a,
          children.map(&:to_ast),
        ]]
      end
    end
  end
end
