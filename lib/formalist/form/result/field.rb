require "formalist/validation/value_rules_compiler"
require "formalist/validation/predicate_list_compiler"

module Formalist
  class Form
    class Result
      class Field
        attr_reader :definition, :input, :rules, :predicates, :errors

        def initialize(definition, input, rules, errors)
          rules_compiler = Validation::ValueRulesCompiler.new(definition.name)
          predicates_compiler = Validation::PredicateListCompiler.new

          @definition = definition
          @input = input[definition.name]
          @rules = rules_compiler.(rules)
          @predicates = predicates_compiler.(@rules)
          @errors = errors[definition.name] || []
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

          [:field, [
            definition.name,
            definition.type,
            definition.display_variant,
            input,
            predicates,
            errors,
            definition.config.to_a,
          ]]
        end
      end
    end
  end
end
