require "forwardable"

module Formalist
  class Form
    class ValidatedResult
      extend Forwardable

      def_delegators :@result,
        :input,
        :schema,
        :elements,
        :validation,
        :output

      # @api private
      attr_reader :result

      def initialize(result)
        @result = result
      end

      def success?
        validation.success?
      end

      def messages
        validation.messages
      end

      def to_ast
        elements.map { |el| el.(output, schema.rules.map(&:to_ary), messages).to_ast }
      end
    end
  end
end
