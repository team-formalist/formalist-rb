require "formalist/form/definition_context"

module Formalist
  class Form
    module Definition
      def attr(name, &block)
        elements << [:attr, [name, define_children(&block)]]
      end

      def component(display: "default", **config, &block)
        elements << [:component, [display, config, define_children(&block)]]
      end

      def field(name, type:, display: "default", **config)
        elements << [:field, [name, type, display, config.to_a]]
      end

      def group(**config, &block)
        elements << [:group, [config, define_children(&block)]]
      end

      def many(name, **config, &block)
        elements << [:many, [name, config, define_children(&block)]]
      end

      def section(name, **config, &block)
        elements << [:section, [name, config, define_children(&block)]]
      end

      private

      def define_children(&block)
        block ? DefinitionContext.new(&block).elements : []
      end
    end
  end
end
