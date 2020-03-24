module Formalist
  class Element
    class Attributes
      # Returns the attributes hash.
      attr_reader :attrs, :meta

      # Creates an attributes object from the supplied hash.
      #
      # @param attrs [Hash] hash of form element attributes
      def initialize(attrs = {}, meta: {})
        @attrs = attrs
        @meta = meta
      end

      # Returns the attributes as an abstract syntax tree.
      #
      # @return [Array] the abstract syntax tree
      def to_ast
        deep_to_ast(deep_simplify(attrs))
      end

      private

      def deep_to_ast(value)
        case value
          when Hash
            [:object, [value.map { |k,v| [k.to_sym, deep_to_ast(v)] }].reject(&:empty?).flatten(1)]
          when Array
            [:array, value.map { |v| deep_to_ast(v) }]
          when String, Numeric, TrueClass, FalseClass, NilClass
            [:value, [value]]
          when Proc
            deep_to_ast(value.call(meta))
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
          when Proc
            deep_simplify(value.call(meta))
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
