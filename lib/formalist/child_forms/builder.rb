require "json"
require_relative "child_form"

module Formalist
  module ChildForms
    class Builder
      attr_reader :embedded_forms

      def initialize(embedded_form_collection)
        @embedded_forms = embedded_form_collection
      end

      def call(input)
        return input if input.nil?

        input = input.is_a?(String) ? JSON.parse(input) : input

        input.map { |node| visit(node) }
      end
      alias_method :[], :call

      private

      def visit(node)
        name, data = node.values_at(:name, :data)

        embedded_form = embedded_forms[name]
        child_form(name, embedded_form).fill(input: data)
      end

      def child_form(name, embedded_form)
        ChildForm.build(
          name: name,
          attributes: {
            label: embedded_form.label,
            form: embedded_form.form,
            schema: embedded_form.schema,
            input_processor: embedded_form.input_processor,
            preview_image_url: embedded_form.preview_image_url
          }
        )
      end
    end
  end
end
