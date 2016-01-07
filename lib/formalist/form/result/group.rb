module Formalist
  class Form
    class Result
      class Group
        attr_reader :definition, :input, :errors

        def initialize(definition, input, errors)
          @definition = definition
          @input = input
          @errors = errors
        end

        def to_ary
          [:group, [definition.elements.map { |el| el.(input, errors).to_ary }, definition.config.to_a]]
        end
      end
    end
  end
end
