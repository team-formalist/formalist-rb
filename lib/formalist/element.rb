require "formalist/element/attributes"
require "formalist/element/class_interface"
require "formalist/types"

module Formalist
  class Element
    extend ClassInterface

    # @api private
    attr_reader :attributes, :children, :input, :errors

    # @api private
    def initialize(*args, attributes, children, input, errors)
      # Set supplied attributes or their defaults
      full_attributes = self.class.attributes_schema.each_with_object({}) { |(name, defn), memo|
        value = attributes[name] || defn[:default]
        memo[name] = value unless value.nil?
      }

      # Then run them through the schema
      @attributes = Types::Hash.schema(self.class.attributes_schema.map { |name, defn| [name, defn[:type]] }.to_h).(full_attributes)

      @input = input
      @errors = errors
      @children = children.map(&method(:build_child))
    end

    # Returns the element's type, which is a symbolized, camlized
    # representation of the element's class name.
    #
    # This is a critical hook for customising form rendering when using custom
    # form elements, since the type in this case will be based on the name of
    # form element's sublass.
    #
    # @example Basic element
    #   field.type # => :field
    #
    # @example Custom element
    #   my_field.type # => :my_field
    #
    # @return [Symbol] the element type.
    def type
      self.class.type
    end

    # Build a given child of the form element using the element's input and
    # errors.
    #
    # Override this in a subclass if you need to customise how children are built.
    #
    # @api private
    def build_child(definition)
      definition.(input, errors)
    end

    # @abstract
    def to_ast
      raise NotImplementedError
    end
  end
end
