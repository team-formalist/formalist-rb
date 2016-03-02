require "inflecto"
require "formalist/element/class_interface"

module Formalist
  class Element
    extend ClassInterface

    attr_reader :attributes, :children, :input, :rules, :errors

    def initialize(attributes, children, input, rules, errors)
      @attributes = attributes
      @input = input
      @rules = rules
      @errors = errors

      prepare
      @children = children.map(&method(:prepare_child))
    end

    def prepare
      # No op by default
    end

    def prepare_child(definition)
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
