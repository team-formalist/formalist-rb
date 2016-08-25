require "json"
require "dry-logic"
require "formalist/rich_text/validity_check"

module Formalist
  module Logic
    module Predicates
      extend Dry::Logic::PredicateSet

      predicate :embedded_forms_valid? do |text|
        text = text.kind_of?(Array) ? text : JSON.parse(text)

        RichText::ValidityCheck.new.(text)
      end
    end
  end
end
