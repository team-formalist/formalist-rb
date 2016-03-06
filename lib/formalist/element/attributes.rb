module Formalist
  class Element
    class Attributes
      attr_reader :attrs

      def initialize(attrs = {})
        @attrs = attrs
      end

      def to_ast
        deep_to_ast(deep_simplify(attrs))
      end

      private

      def deep_to_ast(value)
        case value
          when Hash
            [:object, [value.map { |k,v| [k.to_sym, deep_to_ast(v)] }.flatten(1)]]
          when Array
            [:array, [value.map { |v| deep_to_ast(v) }]]
          when String, Numeric, TrueClass, FalseClass, NilClass
            [:value, [value]]
          else
            [:value, [value.to_s]]
        end
      end

      def deep_simplify(value)
        case value
          when Hash
            value.each_with_object({}) { |(k,v), output| output[k] = deep_simplify(v) }
          when Array
            value.map { |v| deep_simplify(v) }
          when String, Numeric, TrueClass, FalseClass, NilClass
            value
          else
            if value.respond_to?(:to_h)
              deep_simplify(value.to_h)
            else
              value.to_s
            end
        end
      end
    end
  end
end
