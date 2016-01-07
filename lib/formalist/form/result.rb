module Formalist
  class Form
    class Result
      attr_reader :elements

      def initialize(elements)
        @elements = elements
      end

      def to_ary
        elements.map(&:to_ary)
      end
    end
  end
end
