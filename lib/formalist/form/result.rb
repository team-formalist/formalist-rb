require "dry-validation"

module Formalist
  class Form
    class Result
      # @api private
      attr_reader :form

      # @api private
      attr_reader :input

      # @api private
      attr_reader :messages

      # @api private
      attr_reader :elements

      def initialize(form, input_or_result)
        @form = form

        if input_or_result.is_a?(Dry::Validation::Schema::Result)
          @input = input_or_result.output
          @messages = input_or_result.messages
        else
          @input = input_or_result
          @messages = {}
        end

        @elements = form.elements.map { |el| el.(input, form.schema.rules.map(&:to_ary), messages) }
      end

      def to_ast
        elements.map(&:to_ast)
      end
    end
  end
end
