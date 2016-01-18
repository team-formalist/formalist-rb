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
          @errors = errors[definition.name].to_a[0] || []
        end

        def to_ary
          # errors looks like this
          # {:field_name => [["pages is missing", "another error message"], nil]}

          [:field, [
            definition.name,
            definition.type,
            definition.display_variant,
            Dry::Data[definition.type].(input),
            predicates,
            errors,
            definition.config.to_a,
          ]]
        end
      end
    end
  end
end
