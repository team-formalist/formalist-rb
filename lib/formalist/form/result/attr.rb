module Formalist
  class Form
    class Result
      class Attr
        attr_reader :definition, :input, :errors
        attr_reader :children

        def initialize(definition, input, errors)
          @definition = definition
          @input = input.fetch(definition.name, {})
          @errors = errors.fetch(definition.name, [])[0] || []
          @children = build_children
        end

        def to_ary
          # Errors, if the attr hash is present and its members have errors:
          # {:meta=>[[{:pages=>[["pages is missing"], nil]}], {}]}

          # Errors, if the attr hash hasn't been provided
          # {:meta=>[["meta is missing"], nil]}

          local_errors = errors[0].is_a?(Hash) ? [] : errors
          [:attr, [definition.name, children.map(&:to_ary), local_errors]]
        end

        private

        def build_children
          child_errors = errors[0].is_a?(Hash) ? errors[0] : {}
          definition.children.map { |el| el.(input, child_errors) }
        end
      end
    end
  end
end
