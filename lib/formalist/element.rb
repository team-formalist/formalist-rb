require "formalist/element/attributes"
require "formalist/element/class_interface"
require "formalist/types"

module Formalist
  class Element
    extend ClassInterface

    attr_reader :attributes, :children, :input, :rules, :errors

    def initialize(attributes, children, input, rules, errors)
      # Make the attributes completely match the schema, so type defaults can apply
      complete_attributes = self.class.schema.each_with_object({}) { |(key, _val), memo|
        memo[key] = attributes[key]
      }
      # Then remove any keys for values that are still nil
      @attributes = Types::Hash.schema(self.class.schema).(complete_attributes).each_with_object({}) { |(key, val), memo|
        memo[key] = val unless val.nil?
      }

      @input = input
      @rules = rules
      @errors = errors
      @children = children.map(&method(:build_child))
    end

    def type
      self.class.type
    end

    def build_child(definition)
      definition.(input, rules, errors)
    end

    def to_ast
      raise NotImplementedError
    end
  end
end
