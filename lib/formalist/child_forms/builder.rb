require "json"
require "formalist/elements/child_form"

module Formalist
  module ChildForms
    class Builder
      attr_reader :embedded_forms
      attr_reader :child_form_class

      def initialize(embedded_form_collection, child_form_class = Elements::ChildForm)
        @embedded_forms = embedded_form_collection
        @child_form_class = child_form_class
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

        child = child_form_class.build(
          name: node[:name],
          attributes: {
            label: embedded_form.label,
            form: embedded_form.form,
            schema: embedded_form.schema,
            input_processor: embedded_form.input_processor,
          }
        )

        child.fill(input: {node[:name] => node[:data]})

      end
    end
  end
end
