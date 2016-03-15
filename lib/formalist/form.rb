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

    # @api public
    def self.define(&block)
      @elements = DefinitionContext.new(
        container: config.elements_container,
        permissions: Element::PermittedChildren.all
      ).call(&block).elements
    end

    # @api public
    def initialize(options = {})
    end

    # @api public
    def build(input = {}, messages = {})
      elements = self.class.elements.map { |el| el.resolve(self) }
      Result.new(input, messages, elements)
    end
  end
end
