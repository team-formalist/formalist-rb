module Formalist
  module RichText

    # Our input data looks like this (this is a text line, embedded form data,
    # then another text line):
    #
    # [
    #   ["block",["unstyled","b14hd",[["inline",[[],"Before!"]]]]],
    #   ["block",["atomic","48b4f",[["entity",["formalist","1","IMMUTABLE",{"name":"image_with_caption","label":"Image with caption","data":{"image_id":"5678","caption":"Large panda"}},[["inline",[[],"¶"]]]]]]]],
    #   ["block",["unstyled","aivqi",[["inline",[[],"After!"]]]]]
    # ]
    #
    # We want to intercept the embededed form data and turn them back into
    # full form ASTs, complete with validation messages.

    class EmbeddedFormCompiler
      attr_reader :embedded_forms

      def initialize(embedded_form_collection)
        @embedded_forms = embedded_form_collection
      end

      def call(ast)
        ast.map { |node| visit(node) }
      end

      private

      def visit(node)
        name, nodes = node

        handler = :"visit_#{name}"

        if respond_to?(handler, true)
          send(:"visit_#{name}", nodes)
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

        if type == "formalist"
          form_ast = prepare_form_ast(
            embedded_forms[entity_data[:name]],
            entity_data[:data]
          )

          entity_data = entity_data.merge(form: form_ast)
        end

        ["entity", [type, key, mutability, entity_data, children]]
      end

      def prepare_form_ast(embedded_form, data)
        form = embedded_form.form

        errors = if embedded_form.schema
          embedded_form.schema.(data).messages
        else
          {}
        end

        form.build(data, errors).to_ast
      end
    end
  end
end
