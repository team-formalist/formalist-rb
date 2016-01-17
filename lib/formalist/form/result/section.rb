module Formalist
  class Form
    class Result
      class Section
        attr_reader :definition, :input, :rules, :errors
        attr_reader :children

        def initialize(definition, input, rules, errors)
          @definition = definition
          @input = input
          @rules = rules
          @errors = errors
          @children = definition.children.map { |el| el.(input, rules, errors) }
        end

        def to_ary
          [:section, [
            definition.name,
            definition.config.to_a,
            children.map(&:to_ary),
          ]]
        end
      end
    end
  end
end
