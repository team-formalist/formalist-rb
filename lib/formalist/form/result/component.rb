module Formalist
  class Form
    class Result
      class Component
        attr_reader :definition, :input, :errors
        attr_reader :children

        def initialize(definition, input, errors)
          @definition = definition
          @input = input
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
