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

        nested_input = input.fetch(name, {})
        nested_errors = errors.fetch(name, []).dig(0, 0)
        nested_errors = {} unless nested_errors.is_a?(Hash) # ignore errors if they are for a missing attr

        [:attr, [name, elements.map { |el| el.(nested_input, nested_errors) }]]
      end
    end
  end
end
