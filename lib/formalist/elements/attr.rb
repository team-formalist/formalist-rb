require "formalist/element"
require "formalist/types"
require "formalist/validation/collection_rules_compiler"
require "formalist/validation/value_rules_compiler"
require "formalist/validation/predicate_list_compiler"

module Formalist
  class Elements
    class Attr < Element
      permitted_children :all

      # @api private
      attr_reader :name

      # @api private
      attr_reader :value_rules, :value_predicates, :collection_rules, :child_errors

      # @api private
      def initialize(*args, attributes, children, input, rules, errors)
        super

        @name = Types::ElementName.(args.first)

        value_rules_compiler = Validation::ValueRulesCompiler.new(name)
        value_predicates_compiler = Validation::PredicateListCompiler.new
        collection_rules_compiler = Validation::CollectionRulesCompiler.new(name)

        @input = input.fetch(name, {})
        @value_rules = value_rules_compiler.(rules)
        @value_predicates = value_predicates_compiler.(value_rules)
        @collection_rules = collection_rules_compiler.(rules)
        @errors = errors.fetch(name, [])[0] || []
        @child_errors = errors[0].is_a?(Hash) ? errors[0] : {}
      end

      # @api private
      def build_child(definition)
        definition.(input, collection_rules, child_errors)
      end

      # Converts the attribute into an abstract syntax tree.
      #
      # It takes the following format:
      #
      # ```
      # [:attr, [params]]
      # ```
      #
      # With the following parameters:
      #
      # 1. Attribute name
      # 2. Custom element type (or `:attr` otherwise)
      # 3. Validation rules (if any)
      # 4. Validation error messages (if any)
      # 5. Form element attributes
      # 6. Child form elements
      #
      # @see Formalist::Element::Attributes#to_ast "Form element attributes" structure
      #
      # @example "metadata" attr
      #   attr.to_ast
      #   # => [:attr, [
      #     :metadata,
      #     :attr,
      #     [[:predicate, [:hash?, []]]],
      #     ["metadata is missing"],
      #     [:object, []],
      #     [...child elements...]
      #   ]]
      #
      # @return [Array] the attribute as an abstract syntax tree.
      def to_ast
        # Errors, if the attr hash is present and its members have errors:
        # {:meta=>[[{:pages=>[["pages is missing"], nil]}], {}]}

        # Errors, if the attr hash hasn't been provided
        # {:meta=>[["meta is missing"], nil]}

        local_errors = errors[0].is_a?(Hash) ? [] : errors

        [:attr, [
          name,
          type,
          value_predicates,
          local_errors,
          Element::Attributes.new(attributes).to_ast,
          children.map(&:to_ast),
        ]]
      end
    end
  end
end
