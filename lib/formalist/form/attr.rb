require "formalist/form/definition"

module Formalist
  class Form
    class Attr
      include Definition.with_builders(:group, :section, :field)

      attr_reader :name

      def initialize(name, &block)
        @name = name
        yield(self)
      end

      def call(input)
        [:attr, [name, elements.map { |el| el.(input[name] || {}) }]]
      end
    end
  end
end
