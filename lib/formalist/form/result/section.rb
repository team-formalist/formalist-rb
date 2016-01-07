module Formalist
  class Form
    class Result
      class Section
        attr_reader :definition, :input, :errors

        def initialize(definition, input, errors)
          @definition = definition
          @input = input
          @errors = errors
        end

        def to_ary
          [:section, [definition.name, definition.elements.map { |el| el.(input, errors).to_ary }, definition.config.to_a]]
        end
      end
    end
  end
end
