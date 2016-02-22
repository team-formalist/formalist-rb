require "formalist/form/validated_result"

module Formalist
  class Form
    class Result
      # @api private
      attr_reader :input

      # @api private
      attr_reader :schema

      # @api private
      attr_reader :elements

      # @api public
      attr_reader :validation

      def initialize(schema, elements, input)
        @input = input
        @schema = schema
        @elements = elements
        @validation = schema.(input)
      end

      def output
        validation.output
      end

      def success?
        true
      end

      def messages
        {}
      end

      def to_ast
        elements.map { |el| el.(output, schema.rules.map(&:to_ary), messages).to_ast }
      end

      def validate
        ValidatedResult.new(self)
      end
    end
  end
end
