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

        def to_ary
          local_errors = errors[0].is_a?(String) ? errors : []

          [:many, [
            definition.name,
            value_predicates,
            local_errors,
            definition.config.to_a,
            child_template.map(&:to_ary),
            children.map { |el_list| el_list.map(&:to_ary) },
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
            local_child_errors = child_errors.map { |error| error[definition.name] }.detect { |error| error[1] == child_input }.to_a.dig(0, 0) || {}

            definition.children.map { |el| el.(child_input, collection_rules, local_child_errors) }
          }
        end
      end
    end
  end
end
