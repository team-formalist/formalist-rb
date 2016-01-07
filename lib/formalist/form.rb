require "dry-configurable"
require "formalist/display_adapters"
require "formalist/form/definition"
require "formalist/form/result"

module Formalist
  class Form
    extend Dry::Configurable
    extend Definition.with_builders(:attr, :field, :group, :many, :section)

    setting :display_adapters, DisplayAdapters

    def self.display_adapters
      config.display_adapters
    end

    # @api private
    attr_reader :schema

    def initialize(schema: nil)
      @schema = schema
    end

    def call(input, validate: true)
      error_messages = validate && schema ? schema.(input).messages : {}

      Result.new(self.class.elements.map { |el| el.(input, error_messages) })
    end
  end
end
