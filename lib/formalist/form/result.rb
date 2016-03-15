module Formalist
  class Form
    class Result
      # @api private
      attr_reader :input

      # @api private
      attr_reader :messages

      # @api private
      attr_reader :elements

      def initialize(input, messages, elements)
        @input = input
        @messages = messages
        @elements = elements.map { |el| el.(input, messages) }
      end

      def to_ast
        elements.map(&:to_ast)
      end
    end
  end
end
