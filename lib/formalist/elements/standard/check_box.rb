require "formalist/element"
require "formalist/elements"

module Formalist
  class Elements
    class CheckBox < Field
      attribute :question_text

      def initialize(*)
        super

        # Ensure value is a boolean (also: default to false for nil values)
        @input = !!@input
      end
    end

    register :check_box, CheckBox
  end
end
