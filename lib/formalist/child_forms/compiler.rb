require "json"

module Formalist
  module ChildForms
    class Compiler
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
        embedded_form = embedded_forms[node[:name]]

        node.merge(
          :label => embedded_form.label,
          :form => fill_form(embedded_form, node[:data])
        )
      end

      def fill_form(embedded_form, data)
        # Run the raw data through the validation schema
        validation = embedded_form.schema.(data)

        # And then through the embedded form's input processor (which may add
        # extra system-generated information necessary for the form to render
        # fully)
        input = embedded_form.input_processor.(validation.to_h)

        embedded_form.form.fill(input: input, errors: validation.errors.to_h).to_ast
      end
    end
  end
end
