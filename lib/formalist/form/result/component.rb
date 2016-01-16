module Formalist
  class Form
    class Result
      class Component
        attr_reader :definition, :input, :rules, :errors
        attr_reader :children

        def initialize(definition, input, errors)
          @definition = definition
          @input = input
          @rules = rules # TODO
          @errors = errors
          @children = definition.children.map { |el| el.(input, errors) }
        end

        def to_ary
          [:component, [children.map(&:to_ary), definition.config.to_a]]
        end
      end
    end
  end
end
