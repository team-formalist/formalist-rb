require "formalist/element"
require "formalist/elements"
require "formalist/types"

module Formalist
  class Elements
    class CheckBox < Field
      attribute :question_text, Types::String

      def initialize(*)
        super

        # Ensure value is a boolean (also: default to false for nil values)
        @input = !!@input
      end
    end

    register :check_box, CheckBox
  end
end
