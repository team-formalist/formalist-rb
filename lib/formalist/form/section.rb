require "formalist/form/definition"

module Formalist
  class Form
    class Section
      include Definition.with_builders(:attr, :field, :group, :many, :section)

      attr_reader :name
      attr_reader :config

      def initialize(name, **config, &block)
        @name = name
        @config = config
        yield(self)
      end

      def call(input, errors)
        [:section, [name, elements.map { |el| el.(input, errors) }, config.to_a]]
      end
    end
  end
end
