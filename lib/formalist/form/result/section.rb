module Formalist
  class Form
    class Result
      class Section
        attr_reader :definition, :input, :rules, :errors
        attr_reader :children

        def initialize(definition, input, rules, errors)
          @definition = definition
          @input = input
          @rules = rules
          @errors = errors
          @children = definition.children.map { |el| el.(input, rules, errors) }
        end

        # Converts the section into an array format for including in a form's
        # abstract syntax tree.
        #
        # The array takes the following format:
        #
        # ```
        # [:section, [params]]
        # ```
        #
        # With the following parameters:
        #
        # 1. Section name
        # 1. Section configuration
        # 1. Child form elements
        #
        # @example "content" section
        #   section.to_ast # =>
        #   # [:section, [
        #   #   :content,
        #   #   [
        #   #     [:some_config_name, :some_config_value]
        #   #   ],
        #   #   [
        #   #     ...child elements...
        #   #   ]
        #   # ]]
        #
        # @return [Array] the section as an array.
        def to_ast
          [:section, [
            definition.name,
            definition.config.to_a,
            children.map(&:to_ast),
          ]]
        end
      end
    end
  end
end
