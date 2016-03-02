require "formalist/element/definition"

module Formalist
  class Form
    class DefinitionContext
      attr_reader :container
      attr_reader :permissions
      attr_reader :elements

      def initialize(elements = [], container:, permissions:)
        @elements = elements
        @container = container
        @permissions = permissions
      end

      def with(elements = [], **options)
        options[:container] ||= container
        options[:permissions] ||= permissions

        self.class.new(elements, **options)
      end

      def call(&block)
        instance_eval(&block) if block
        self
      end

      def add_element(element_type, *args, &block)
        raise ArgumentError, "element +#{element_type}+ is not permitted in this context" unless permissions.permitted?(element_type)

        args = args.dup
        options = args.last.is_a?(Hash) ? args.pop : {}
        name = args.shift
        options = {name: name}.merge(options) if name

        type = container[element_type]
        children = with(permissions: type.permitted_children).call(&block).elements
        definition = Element::Definition.build(type, options, children)

        elements << definition
      end

      def element_exists?(type)
        container.key?(type)
      end

      def method_missing(name, *args, &block)
        return add_element(name, *args, &block) if element_exists?(name)
        super
      end

      def respond_to_missing?(name)
        element_exists?(name)
      end
    end
  end
end
