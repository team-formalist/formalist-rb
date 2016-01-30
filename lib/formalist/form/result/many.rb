require "formalist/validation/collection_rules_compiler"
require "formalist/validation/value_rules_compiler"
require "formalist/validation/predicate_list_compiler"

module Formalist
  class Form
    class Result
      class Many
        attr_reader :definition, :input, :value_rules, :value_predicates, :collection_rules, :errors
        attr_reader :child_template, :children

        def initialize(definition, input, rules, errors)
          value_rules_compiler = Validation::ValueRulesCompiler.new(definition.name)
          value_predicates_compiler = Validation::PredicateListCompiler.new
          collection_rules_compiler = Validation::CollectionRulesCompiler.new(definition.name)

          @definition = definition
          @input = input.fetch(definition.name, [])
          @value_rules = value_rules_compiler.(rules)
          @value_predicates = value_predicates_compiler.(@value_rules)
          @collection_rules = collection_rules_compiler.(rules)
          @errors = errors.fetch(definition.name, [])[0] || []
          @child_template = build_child_template
          @children = build_children
        end

        # Converts a collection of "many" repeating elements into an array
        # format for including in a form's abstract syntax tree.
        #
        # The array takes the following format:
        #
        # ```
        # [:many, [params]]
        # ```
        #
        # With the following parameters:
        #
        # 1. Collection array name
        # 1. Collection validation rules (if any)
        # 1. Collection error messages (if any)
        # 1. Collection configuration
        # 1. Child element "template" (i.e. the form elements comprising a
        #    single entry in the collection of "many" elements, without any
        #    user data associated)
        # 1. Child elements, one for each of the entries in the input data (or
        #    none, if there is no or empty input data)
        #
        # @example "locations" collection
        #   many.to_ast # =>
        #   # [:many, [
        #   #   :locations,
        #   #   [[:predicate, [:min_size?, [3]]]],
        #   #   ["locations size cannot be less than 3"],
        #   #   [
        #   #     [:allow_create, true],
        #   #     [:allow_update, true],
        #   #     [:allow_destroy, true],
        #   #     [:allow_reorder, true]
        #   #   ],
        #   #   [
        #   #     [:field, [:name, "string", "default", nil, [], [], []]],
        #   #     [:field, [:address, "string", "default", nil, [], [], []]]
        #   #   [
        #   #     [
        #   #       [:field, [:name, "string", "default", "Icelab Canberra", [], [], []]],
        #   #       [:field, [:address, "string", "default", "Canberra, ACT, Australia", [], [], []]]
        #   #     ],
        #   #     [
        #   #       [:field, [:name, "string", "default", "Icelab Melbourne", [], [], []]],
        #   #       [:field, [:address, "string", "default", "Melbourne, VIC, Australia", [], [], []]]
        #   #     ]
        #   #   ]
        #   # ]]
        #
        # @return [Array] the collection as an array.
        def to_ast
          local_errors = errors.select { |e| e.is_a?(String) }

          [:many, [
            definition.name,
            value_predicates,
            local_errors,
            definition.config.to_a,
            child_template.map(&:to_ast),
            children.map { |el_list| el_list.map(&:to_ast) },
          ]]
        end

        private

        def build_child_template
          template_input = {}
          template_errors = {}

          definition.children.map { |el| el.(template_input, collection_rules, template_errors)}
        end

        def build_children
          # child errors looks like this:
          # {:links=>
          #   [[{:links=>
          #       [[{:url=>[["url must be filled"], ""]}],
          #        {:name=>"personal", :url=>""}]}],
          #    [{:name=>"company", :url=>"http://icelab.com.au"},
          #     {:name=>"personal", :url=>""}]]}
          #
          # or local errors:
          # {:links=>[["links is missing"], nil]}

          child_errors = errors[0].is_a?(Hash) ? errors : {}

          input.map { |child_input|
            local_child_errors = child_errors.select { |e|
              e.is_a?(Hash)
            }.map { |e|
              e[definition.name]
            }.detect { |e|
              e[1] == child_input
            }.to_a.dig(0, 0) || {}

            definition.children.map { |el| el.(child_input, collection_rules, local_child_errors) }
          }
        end
      end
    end
  end
end
