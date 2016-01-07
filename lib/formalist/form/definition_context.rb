module Formalist
  class Form
    # @api private
    class DefinitionContext
      include Definition

      attr_reader :elements

      def initialize(&block)
        @elements = []
        yield(self)
      end
    end
  end
end
