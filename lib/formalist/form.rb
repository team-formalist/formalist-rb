require "dry/configurable"
require "dry/core/constants"
require "formalist/elements"
require "formalist/definition"

module Formalist
  class Form
    extend Dry::Configurable
    include Dry::Core::Constants

    setting :elements_container, Elements

    class << self
      attr_reader :definition

      def define(&block)
        @definition = block
      end
    end

    attr_reader :elements
    attr_reader :input
    attr_reader :errors
    attr_reader :dependencies

    def initialize(elements: Undefined, input: {}, errors: {}, **dependencies)
      @input = input
      @errors = errors

      @elements =
        if elements == Undefined
          Definition.new(self, self.class.config, &self.class.definition).elements
        else
          elements
        end

      @dependencies = dependencies
    end

    def fill(input: {}, errors: {})
      return self if input == @input && errors == @errors

      self.class.new(
        elements: @elements.map { |element| element.fill(input: input, errors: errors) },
        input: input,
        errors: errors,
        **@dependencies,
      )
    end

    def with(**new_dependencies)
      self.class.new(
        elements: @elements,
        input: @input,
        errors: @errors,
        **@dependencies.merge(new_dependencies)
      )
    end

    def to_ast
      elements.map(&:to_ast)
    end
  end
end
