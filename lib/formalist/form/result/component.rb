module Formalist
  class Form
    class Result
      class Component
        attr_reader :definition, :input, :rules, :errors
        attr_reader :children

        def initialize(definition, input, rules, errors)
          @definition = definition
          @input = input
          @rules = rules
          @errors = errors
          @children = definition.children.map { |el| el.(input, rules, errors) }
        end

        # Converts the component into an array format for including in a
        # form's abstract syntax tree.
        #
        # The array takes the following format:
        #
        # ```
        # [:component, [params]]
        # ```
        #
        # With the following parameters:
        #
        # 1. Component configuration
        # 1. Child form elements
        #
        # @example
        #   component.to_ary # =>
        #   # [:component, [
        #   #   [
        #   #     [:some_config_name, :some_config_value]
        #   #   ],
        #   #   [
        #   #     ...child elements...
        #   #   ]
        #   # ]]
        #
        # @return [Array] the component as an array.
        def to_ary
          [:component, [
            definition.config.to_a,
            children.map(&:to_ary),
          ]]
        end
      end
    end
  end
end
