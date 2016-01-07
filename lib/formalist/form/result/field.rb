module Formalist
  class Form
    class Result
      class Field
        attr_reader :definition, :input, :errors

        def initialize(definition, input, errors)
          @definition = definition
          @input = input[definition.name]
          @errors = errors[definition.name].to_a[0] || []
        end

        def to_ary
          # errors looks like this
          # {:field_name => [["pages is missing", "another error message"], nil]}

          [:field, [definition.name, definition.type, Dry::Data[definition.type].(input), errors, definition.config.to_a]]
        end
      end
    end
  end
end
