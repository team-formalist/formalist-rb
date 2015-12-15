require "formalist/form/definition"

module Formalist
  class Form
    class Many
      DEFAULT_CONFIG = {
        allow_create: true,
        allow_update: true,
        allow_destroy: true,
        allow_reorder: true
      }.freeze

      include Definition.with_builders(:attr, :group, :field)

      attr_reader :name
      attr_reader :config

      def initialize(name, **config, &block)
        @name = name
        @config = DEFAULT_CONFIG.merge(config)
        yield(self)
      end

      def call(input)
        children = input[name].to_a.map { |child_input|
          elements.map { |el| el.(child_input) }
        }

        [:many, [name, children, config.to_a]]
      end
    end
  end
end
