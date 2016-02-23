module Formalist
  DEFAULT_DISPLAY_ADAPTER = "default".freeze
end

# Temporarily monkey-patch over a dry-validation bug (intput type compiler for
# form schemas not being passed the right set of rules).
require "dry-validation"
require "dry/validation/schema/form"
module Dry
  module Validation
    class Schema::Form < Schema
      def initialize(rules = [])
        super
        # @input_type = InputTypeCompiler.new.(self.class.rules.map(&:to_ast))
        @input_type = InputTypeCompiler.new.(self.class.rule_ast + rules.map(&:to_ast))
      end
    end
  end
end

require "formalist/form"
