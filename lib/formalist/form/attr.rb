require "formalist/form/definition"

module Formalist
  class Form
    class Attr
      include Definition.with_builders(:group, :section, :field)

      attr_reader :name

      def initialize(name, form: nil, &block)
        @name = name
        yield(self)
      end

      def call(input, errors)
        # Errors, if the attr hash is present and its members have errors:
        # {:meta=>[[{:pages=>[["pages is missing"], nil]}], {}]}

        # Errors, if the attr hash hasn't been provided
        # {:meta=>[["meta is missing"], nil]}

        input = input.fetch(name, {})

        errors = errors.fetch(name, [])[0]
        local_errors = errors[0].is_a?(Hash) ? [] : errors
        child_errors = errors[0].is_a?(Hash) ? errors[0] : {}

        [:attr, [name, elements.map { |el| el.(input, child_errors) }, local_errors]]
      end
    end
  end
end
