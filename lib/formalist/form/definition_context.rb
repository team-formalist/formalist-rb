require "formalist/element/definition"

module Formalist
  class Form
    class DefinitionContext
      DuplicateDefinitionError = Class.new(StandardError)

      attr_reader :elements
      attr_reader :config

      def initialize(config)
        @elements = []
        @config = config
      end

      def with(options = {})
        new_config = options.each_with_object(config.dup) { |(key, value), config|
          config.send :"#{key}=", value
        }

        self.class.new(new_config)
      end

      def call(&block)
        instance_eval(&block) if block
        self
      end

      def dep(name)
        Element::Definition::Deferred.new(name)
      end

      def method_missing(name, *args, &block)
        return add_element(name, *args, &block) if element_type_exists?(name)
        super
      end

      def respond_to_missing?(name)
        element_type_exists?(name)
      end

      private

      def element_type_exists?(type)
        config.elements_container.key?(type)
      end

      def add_element(element_type, *args, &block)
        type = config.elements_container[element_type]
        raise ArgumentError, "element +#{element_type}+ is not permitted in this context" unless config.permitted_children.permitted?(type)

        # Work with positional args and a trailing attributes hash
        args = args.dup
        attributes = args.last.is_a?(Hash) ? args.pop : {}

        children = with(permitted_children: type.permitted_children).call(&block).elements
        definition = Element::Definition.new(type, *args, attributes, children)

        if elements.any? { |el| el == definition }
          raise DuplicateDefinitionError, "element +#{element_type} #{args.map(&:inspect).join(', ')}+ is already defined in this context"
        end

        elements << definition
      end
    end
  end
end
