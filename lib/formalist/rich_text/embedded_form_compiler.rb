require "json"

module Formalist
  module RichText

    # Our input data looks like this example, which consists of 3 elements:
    #
    # 1. A text line
    # 2. embedded form data
    # 3. Another text line
    #
    # [
    #   ["block",["unstyled","b14hd",[["inline",[[],"Before!"]]]]],
    #   ["block",["atomic","48b4f",[["entity",["formalist","1","IMMUTABLE",{"name":"image_with_caption","label":"Image with caption","data":{"image_id":"5678","caption":"Large panda"}},[["inline",[[],"¶"]]]]]]]],
    #   ["block",["unstyled","aivqi",[["inline",[[],"After!"]]]]]
    # ]
    #
    # We want to intercept the embededed form data and transform them into full
    # form ASTs, complete with validation messages.

    class EmbeddedFormCompiler
      attr_reader :embedded_forms

      def initialize(embedded_form_collection)
        @embedded_forms = embedded_form_collection
      end

      def call(ast)
        return ast if ast.nil?

        ast = ast.is_a?(String) ? JSON.parse(ast) : ast

        ast.map { |node| visit(node) }
      end
      alias_method :[], :call

      private

      def visit(node)
        name, nodes = node

        handler = :"visit_#{name}"

        if respond_to?(handler, true)
          send(handler, nodes)
        else
          [name, nodes]
        end
      end

      # We need to visit blocks in order to get to the formalist entities nested within them
      def visit_block(node)
        type, id, children = node

        ["block", [type, id, children.map { |child| visit(child) }]]
      end

      def visit_entity(node)
        type, key, mutability, entity_data, children = node

        return ["entity", node] unless type == "formalist"

        embedded_form = embedded_forms[entity_data["name"]]

        compiled_entity_data = entity_data.merge(
          "label" => embedded_form.label,
          "form" => prepare_form_ast(embedded_form, entity_data["data"])
        )

        ["entity", [type, key, mutability, compiled_entity_data, children]]
      end

      def prepare_form_ast(embedded_form, data)
        # Run the raw data through the validation schema
        validation = embedded_form.schema.(data)

        # And then through the embedded form's input processor (which may add
        # extra system-generated information necessary for the form to render
        # fully)
        input = embedded_form.input_processor.(validation.to_h)

        embedded_form.form.fill(input: input, errors: validation.errors).to_ast
      end
    end
  end
end
