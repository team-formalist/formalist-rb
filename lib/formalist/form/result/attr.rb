module Formalist
  class Form
    class Result
      class Attr
        attr_reader :definition, :input, :errors

        def initialize(definition, input, errors)
          @definition = definition
          @input = input.fetch(definition.name, {})
          @errors = errors.fetch(definition.name, [])[0] || []
        end

        def to_ary
          # Errors, if the attr hash is present and its members have errors:
          # {:meta=>[[{:pages=>[["pages is missing"], nil]}], {}]}

          # Errors, if the attr hash hasn't been provided
          # {:meta=>[["meta is missing"], nil]}

          local_errors = errors[0].is_a?(Hash) ? [] : errors
          child_errors = errors[0].is_a?(Hash) ? errors[0] : {}

          [:attr, [definition.name, definition.children.map { |el| el.(input, child_errors).to_ary }, local_errors]]
        end
      end
    end
  end
end
