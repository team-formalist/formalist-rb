require "formalist/form/definition"

module Formalist
  class Form
    class Group
      include Definition.with_builders(:attr, :field, :many)

      attr_reader :config

      def initialize(**config, &block)
        @config = config
        yield(self)
      end

      def call(input, errors)
        [:group, [elements.map { |el| el.(input, errors) }, config.to_a]]
      end
    end
  end
end
