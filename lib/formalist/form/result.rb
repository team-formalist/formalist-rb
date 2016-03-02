module Formalist
  class Form
    class Result
      # @api private
      attr_reader :form

      # @api private
      attr_reader :input

      # @api private
      attr_reader :elements

      def initialize(form, input)
        @form = form
        @input = input
        @elements = form.elements.map { |el| el.(input, form.schema.rules.map(&:to_ary), messages) }
      end

      # TODO: make this show the actual schema messages when we've been handed a dry-v schema result
      def messages
        {}
      end

      def to_ast
        elements.map(&:to_ast)
      end
    end
  end
end
