require "inflecto"
require "formalist/element/class_interface"
require "formalist/types"

module Formalist
  class Element
    extend ClassInterface

    attr_reader :attributes, :children, :input, :rules, :errors

    def initialize(attributes, children, input, rules, errors)
      attributes = Types::Hash.schema(self.class.schema).(attributes)

      @attributes = attributes
      @input = input
      @rules = rules
      @errors = errors
      @children = children.map(&method(:build_child))
    end

    def build_child(definition)
      definition.(input, rules, errors)
    end

    def type
      Inflecto.underscore(Inflecto.demodulize(self.class.name)).to_sym
    end

    def to_ast
      raise NotImplementedError
    end
  end
end
