require "formalist/element"
require "formalist/types"
require "formalist/validation/collection_rules_compiler"
require "formalist/validation/value_rules_compiler"
require "formalist/validation/predicate_list_compiler"

module Formalist
  class Elements
    class Many < Element
      permitted_children :attr, :component, :group, :field

      attribute :name, Types::ElementName
      attribute :allow_create, Types::Bool
      attribute :allow_update, Types::Bool
      attribute :allow_destroy, Types::Bool
      attribute :allow_reorder, Types::Bool

      # @api private
      attr_reader :value_rules, :value_predicates, :collection_rules, :child_template

      # @api private
      def initialize(attributes, children, input, rules, errors)
        super

        value_rules_compiler = Validation::ValueRulesCompiler.new(attributes[:name])
        value_predicates_compiler = Validation::PredicateListCompiler.new
        collection_rules_compiler = Validation::CollectionRulesCompiler.new(attributes[:name])

        @input = input.fetch(attributes[:name], [])
        @value_rules = value_rules_compiler.(rules)
        @value_predicates = value_predicates_compiler.(@value_rules)
        @collection_rules = collection_rules_compiler.(rules)
        @errors = errors.fetch(attributes[:name], [])[0] || []
        @child_template = build_child_template(children)
        @children = build_children(children)
      end

      # Until we can put defaults on `Types::Bool`, supply them here
      # @api private
      def attributes
        {
          allow_create: true,
          allow_update: true,
          allow_destroy: true,
          allow_reorder: true,
        }.merge(super)
      end

      # Converts a collection of "many" repeating elements into an abstract
      # syntax tree.
      #
      # It takes the following format:
      #
      # ```
      # [:many, [params]]
      # ```
      #
      # With the following parameters:
      #
      # 1. Collection name
      # 2. Custom form element type (or `:many` otherwise)
      # 3. Collection validation rules (if any)
      # 4. Collection error messages (if any)
      # 5. Form element attributes
      # 6. Child element "template" (i.e. the form elements comprising a
      #    single entry in the collection of "many" elements, without any user
      #    data associated)
      # 7. Child elements, one for each of the entries in the input data (or
      #    none, if there is no or empty input data)
      #
      # @see Formalist::Element::Attributes#to_ast "Form element attributes" structure
      #
      # @example "locations" collection
      #   many.to_ast
      #   # => [:many, [
      #     :locations,
      #     :many,
      #     [[:predicate, [:min_size?, [3]]]],
      #     ["locations size cannot be less than 3"],
      #     [:object, [
      #       [:allow_create, [:value, [true]]],
      #       [:allow_update, [:value, [true]]],
      #       [:allow_destroy, [:value, [true]]],
      #       [:allow_reorder, [:value, [true]]]
      #     ]],
      #     [
      #       [:field, [:name, :field, nil, [], [], [:object, []]]],
      #       [:field, [:address, :field, nil, [], [], [:object, []]]]
      #     ],
      #     [
      #       [
      #         [:field, [:name, :field, "Icelab Canberra", [], [], [:object, []]]],
      #         [:field, [:address, :field, "Canberra, ACT, Australia", [], [], [:object, []]]]
      #       ],
      #       [
      #         [:field, [:name, :field, "Icelab Melbourne", [], [], [:object, []]]],
      #         [:field, [:address, :field, "Melbourne, VIC, Australia", [], [], [:object, []]]]
      #       ]
      #     ]
      #   ]]
      #
      # @return [Array] the collection as an abstract syntax tree.
      def to_ast
        attributes = self.attributes.dup
        name = attributes.delete(:name)

        local_errors = errors.select { |e| e.is_a?(String) }

        [:many, [
          name,
          type,
          value_predicates,
          local_errors,
          Element::Attributes.new(attributes).to_ast,
          child_template.map(&:to_ast),
          children.map { |el_list| el_list.map(&:to_ast) },
        ]]
      end

      private

      def build_child_template(definitions)
        template_input = {}
        template_errors = {}

        definitions.map { |el| el.(template_input, collection_rules, template_errors)}
      end

      def build_children(definitions)
        # child errors looks like this:
        # [
        #   {:rating=>[["rating must be greater than or equal to 1"], 0]},
        #   {:summary=>"Great", :rating=>0},
        #   {:summary=>[["summary must be filled"], ""]},
        #   {:summary=>"", :rating=>1}
        # ]
        #
        # or local errors:
        # {:links=>[["links is missing"], nil]}

        child_errors = errors.each_slice(2).to_a

        input.map { |child_input|
          local_child_errors = child_errors.select { |e|
            e[1] == child_input
          }.to_a.dig(0, 0) || {}

          definitions.map { |el| el.(child_input, collection_rules, local_child_errors) }
        }
      end
    end
  end
end
