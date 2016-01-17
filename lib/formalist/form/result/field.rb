require "formalist/validation/value_rules_compiler"

module Formalist
  class Form
    class Result
      class Field
        attr_reader :definition, :input, :rules, :errors

        def initialize(definition, input, rules, errors)
          rules_compiler = Validation::ValueRulesCompiler.new(definition.name)

          @definition = definition
          @input = input[definition.name]
          @rules = rules_compiler.(rules)
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
            rules,
            errors,
            definition.config.to_a,
          ]]
        end
      end
    end
  end
end
