require "dry-configurable"
require "formalist/elements"
require "formalist/form/definition_context"
require "formalist/element/permitted_children"
require "formalist/form/result"

module Formalist
  class Form
    extend Dry::Configurable

    setting :elements_container, Elements

    # @api private
    def self.elements
      @elements ||= []
    end

    # @api private
    def self.definition_context
      @definition_context ||= DefinitionContext.new(
        elements,
        container: config.elements_container,
        permissions: Element::PermittedChildren.all,
      )
    end

    # @api private
    def self.method_missing(name, *args, &block)
      return super unless definition_context.element_exists?(name)

      definition_context.add_element(name, *args, &block)
    end

    # @pi private
    def self.respond_to_missing?(name, include_private = false)
      definition_context.element_exists?(name)
    end

    # @api private
    attr_reader :elements

    # @api private
    attr_reader :schema

    # TODO: allow other deps here
    def initialize(schema)
      @schema = schema
    end

    def elements_container
      self.class.elements_container
    end

    def elements
      self.class.elements
    end

    # TODO: allow this to work with both hashes and dry-v schema results
    def build(input = {})
      Result.new(self, input)
    end
  end
end
