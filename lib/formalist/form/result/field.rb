module Formalist
  class Form
    class Result
      class Field
        attr_reader :definition, :input, :errors

        def initialize(definition, input, errors)
          @definition = definition
          @input = input
          @errors = errors
        end

        def to_ary
          # errors looks like this
          # {:field_name => [["pages is missing", "another error message"], nil]}
          error_messages = errors[definition.name].to_a[0].to_a

          [:field, [definition.name, definition.type, Dry::Data[definition.type].(input[definition.name]), error_messages, definition.config.to_a]]
        end
      end
    end
  end
end
