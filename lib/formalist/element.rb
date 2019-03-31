require "formalist/element/attributes"
require "formalist/element/class_interface"
require "formalist/types"

module Formalist
  class Element
    extend ClassInterface

    # @api private
    attr_reader :name, :attributes, :children, :input, :errors

    # @api private
    def self.build(**args)
      new(args)
    end

    # @api private
    def self.fill(input: {}, errors: {}, **args)
      new(args).fill(input: input, errors: errors)
    end

    # @api private
    def initialize(name: nil, attributes: {}, children: [], input: nil, errors: [])
      @name = Types::ElementName[name]

      # Set supplied attributes or their defaults
      all_attributes = self.class.attributes_schema.each_with_object({}) { |(name, defn), memo|
        value = attributes.fetch(name) { defn[:default] }
        memo[name] = value unless value.nil?
      }

      # Then run them through the schema
      @attributes = Types::Hash.schema(
        self.class.attributes_schema.map { |name, defn| [name, defn[:type]] }.to_h,
      ).safe[all_attributes]

      @children = children
      @input = input
      @errors = errors
    end

    def fill(input: {}, errors: {}, **args)
      return self if input == @input && errors == @errors

      args = {
        name: @name,
        attributes: @attributes,
        children: @children,
        input: input,
        errors: errors,
      }.merge(args)

      self.class.new(args)
    end

    def type
      self.class.type
    end

    def ==(other)
      name && type == other.type && name == other.name
    end

    # @abstract
    def to_ast
      raise NotImplementedError
    end
  end
end
