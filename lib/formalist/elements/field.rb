require "formalist/element"
require "formalist/types"
require "formalist/validation/value_rules_compiler"
require "formalist/validation/predicate_list_compiler"

module Formalist
  class Elements
    class Field < Element
      permitted_children :none

      attribute :name, Types::ElementName
      attribute :label, Types::String
      attribute :hint, Types::String
      attribute :placeholder, Types::String

      attr_reader :predicates

      def initialize(attributes, children, input, rules, errors)
        super

        rules_compiler = Validation::ValueRulesCompiler.new(attributes[:name])
        predicates_compiler = Validation::PredicateListCompiler.new

        @input = input[attributes[:name]] if input
        @rules = rules_compiler.(@rules)
        @predicates = predicates_compiler.(@rules)
        @errors = (errors[attributes[:name]] || [])[0].to_a
      end

      # Converts the field into an array format for including in a form's
      # abstract syntax tree.
      #
      # The array takes the following format:
      #
      # ```
      # [:field, [params]]
      # ```
      #
      # With the following parameters:
      #
      # 1. Field name
      # 1. Field type
      # 1. Display variant name
      # 1. Input data
      # 1. Validation rules (if any)
      # 1. Validation error messages (if any)
      # 1. Field configuration
      #
      # @example "email" field
      #   field.to_ast # =>
      #   # [:field, [
      #   #   :email,
      #   #   "string",
      #   #   "default",
      #   #   "invalid email value",
      #   #   [
      #   #     [:and, [
      #   #       [:predicate, [:filled?, []]],
      #   #       [:predicate, [:format?, [/\s+@\s+\.\s+/]]]
      #   #     ]]
      #   #   ],
      #   #   ["email is in invalid format"],
      #   #   [
      #   #     [:some_config_name, :some_config_value]
      #   #   ]
      #   # ]]
      #
      # @return [Array] the field as an array.
      def to_ast
        # errors looks like this
        # {:field_name => [["pages is missing", "another error message"], nil]}

        attributes = self.attributes.dup
        name = attributes.delete(:name)

        [:field, [
          name,
          type,
          input,
          predicates,
          errors,
          Element::Attributes.new(attributes).to_ast,
        ]]
      end
    end
  end
end