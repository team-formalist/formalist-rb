require "formalist/validation/targeted_rules_compiler"

module Formalist
  class Form
    class Result
      class Attr
        attr_reader :definition, :input, :rules, :errors
        attr_reader :children

        def initialize(definition, input, rules, errors)
          rules_compiler = Validation::TargetedRulesCompiler.new(definition.name)

          @definition = definition
          @input = input.fetch(definition.name, {})
          @rules = rules_compiler.(rules)
          @errors = errors.fetch(definition.name, [])[0] || []
          @children = build_children
        end

        def to_ary
          # Errors, if the attr hash is present and its members have errors:
          # {:meta=>[[{:pages=>[["pages is missing"], nil]}], {}]}

          # Errors, if the attr hash hasn't been provided
          # {:meta=>[["meta is missing"], nil]}

          local_rules = rules # TODO
          local_errors = errors[0].is_a?(Hash) ? [] : errors

          [:attr, [
            definition.name,
            local_rules,
            local_errors,
            children.map(&:to_ary),
          ]]
        end

        private

        def build_children
          child_errors = errors[0].is_a?(Hash) ? errors[0] : {}
          definition.children.map { |el| el.(input, rules, child_errors) }
        end
      end
    end
  end
end
