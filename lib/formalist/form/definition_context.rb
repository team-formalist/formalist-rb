require "formalist/element/definition"

module Formalist
  class Form
    class DefinitionContext
      attr_reader :elements
      attr_reader :container
      attr_reader :permissions

      def initialize(options = {})
        @elements = []
        @container = options.fetch(:container)
        @permissions = options.fetch(:permissions)
      end

      def with(options = {})
        %i[container permissions].each do |attr|
          options[attr] ||= send(attr)
        end

        self.class.new(options)
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
        container.key?(type)
      end

      def add_element(element_type, *args, &block)
        type = container[element_type]
        raise ArgumentError, "element +#{element_type}+ is not permitted in this context" unless permissions.permitted?(type)

        # Work with top-level args and a trailing attributes hash
        args = args.dup
        attributes = args.last.is_a?(Hash) ? args.pop : {}

        children = with(permissions: type.permitted_children).call(&block).elements
        definition = Element::Definition.new(type, *args, attributes, children)

        elements << definition
      end
    end
  end
end
