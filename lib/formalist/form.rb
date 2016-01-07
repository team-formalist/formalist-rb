require "formalist/form/definition"
require "formalist/form/result"

module Formalist
  class Form
    extend Definition.with_builders(:attr, :field, :group, :many, :section)

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
