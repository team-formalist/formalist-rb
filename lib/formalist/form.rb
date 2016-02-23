require "json"
require "dry-configurable"
require "dry-validation"
require "dry/validation/schema/form"
require "formalist/definition_compiler"
require "formalist/output_compiler"
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
    attr_reader :schema

    # @api private
    attr_reader :elements

    def initialize(schema)
      definition_compiler = DefinitionCompiler.new(self.class.display_adapters)

      @elements = definition_compiler.call(self.class.elements)
      @schema = schema
    end

    def build(input)
      Result.new(schema, elements, input)
    end

    def receive(form_post)
      form_data = Formalist::OutputCompiler.new.call(JSON.parse(form_post))
      form_schema = Dry::Validation::Schema::Form.new(schema.class.rules)

      input = form_schema.(form_data).output
      build(input)
    end
  end
end
