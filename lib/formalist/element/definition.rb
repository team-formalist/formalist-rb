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

      def ==(other)
        # Require a matching type.
        return false if type != other.type

        # If there are no primary args, it means that the element has no real
        # "identifier" that requires uniqueness, so it's safe to say they don't
        # match here.
        return false if args.empty?

        # Otherwise, use the primary args as a marker of a definitions
        # uniqueness. With the current set of base form elements, the primary
        # args only ever contains a name, so this is effectively a uniqueness
        # check on the element's name.
        args == other.args
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

      def call(input, messages)
        type.new(*args, attributes, children, input, messages)
      end
    end
  end
end
