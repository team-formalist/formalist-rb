module Formalist
  class Form
    class Result
      attr_reader :elements

      def initialize(elements)
        @elements = elements
      end

      def to_ast
        elements.map(&:to_ast)
      end
    end
  end
end
