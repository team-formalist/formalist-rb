module Formalist
  class Form
    class Result
      class Group
        attr_reader :definition, :input, :errors
        attr_reader :children

        def initialize(definition, input, rules, errors)
          @definition = definition
          @input = input
          @rules = rules
          @errors = errors
          @children = definition.children.map { |el| el.(input, rules, errors) }
        end

        # Converts the group into an array format for including in a form's
        # abstract syntax tree.
        #
        # The array takes the following format:
        #
        # ```
        # [:group, [params]]
        # ```
        #
        # With the following parameters:
        #
        # 1. Group configuration
        # 1. Child form elements
        #
        # @example
        #   group.to_ary # =>
        #   # [:group, [
        #   #   [
        #   #     [:some_config_name, :some_config_value]
        #   #   ],
        #   #   [
        #   #     ...child elements...
        #   #   ]
        #   # ]]
        #
        # @return [Array] the group as an array.
        def to_ary
          [:group, [
            definition.config.to_a,
            children.map(&:to_ary),
          ]]
        end
      end
    end
  end
end
