require "json"
require "dry-configurable"
require "dry-validation"
require "dry/validation/input_type_compiler"
require "formalist/definition_compiler"
require "formalist/display_adapters"
require "formalist/form/definition"
require "formalist/form/result"

module Formalist
  class Form
    extend Dry::Configurable
    extend Definition

    setting :display_adapters, DisplayAdapters

    def self.display_adapters
      config.display_adapters
    end

    # @api private
    def self.elements
      @__elements__ ||= []
    end

    # @api private
    attr_reader :elements

    # @api private
    attr_reader :schema

    # @api private
    attr_reader :form_post_compiler

    def initialize(schema)
      definition_compiler = DefinitionCompiler.new(self.class.display_adapters)

      @elements = definition_compiler.call(self.class.elements)
      @schema = schema
      @form_post_compiler = Dry::Validation::InputTypeCompiler.new.(schema.class.rules.map(&:to_ast))
    end

    def build(input = {})
      Result.new(schema, elements, input)
    end

    def receive(form_post)
      build(form_post_compiler.(form_post))
    end
  end
end
