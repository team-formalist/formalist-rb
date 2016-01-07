module Formalist
  class Form
    class Result
      class Section
        attr_reader :definition, :input, :errors
        attr_reader :elements

        def initialize(definition, input, errors)
          @definition = definition
          @input = input
          @errors = errors
          @elements = definition.elements.map { |el| el.(input, errors) }
        end

        def to_ary
          [:section, [definition.name, elements.map(&:to_ary), definition.config.to_a]]
        end
      end
    end
  end
end
