require "formalist/types"

module Formalist
  class Element
    class Definition
      Deferred = Struct.new(:name)

      attr_reader :type
      attr_reader :args
      attr_reader :attributes
      attr_reader :children

      def initialize(type, *args, attributes, children)
        @type = type
        @args = args
        @attributes = attributes
        @children = children
      end

      def resolve(scope)
        resolved_args = args.map { |arg|
          arg.is_a?(Deferred) ? scope.send(arg.name) : arg
        }

        resolved_attributes = attributes.each_with_object({}) { |(key, val), hsh|
          hsh[key] = val.is_a?(Deferred) ? scope.send(val.name) : val
        }

        resolved_children = children.map { |c| c.resolve(scope) }

        self.class.new(type, *resolved_args, resolved_attributes, resolved_children)
      end

      def call(input, rules, messages)
        type.new(*args, attributes, children, input, rules, messages)
      end
    end
  end
end
