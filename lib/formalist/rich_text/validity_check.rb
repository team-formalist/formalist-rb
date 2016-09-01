require "formalist/form/validity_check"

module Formalist
  module RichText
    class ValidityCheck
      AST = Struct.new(:ast)

      def call(ast)
        forms = ast.map { |node| visit(node) }.flatten

        form_validity_check = Form::ValidityCheck.new
        forms.all? { |form_ast| form_validity_check.(form_ast.ast) }
      end
      alias_method :[], :call

      private

      def visit(node)
        name, nodes = node

        handler = :"visit_#{name}"

        if respond_to?(handler, true)
          send(handler, nodes)
        else
          []
        end
      end

      # We need to visit blocks in order to get to the formalist entities nested within them
      def visit_block(node)
        type, id, children = node

        children.map { |child| visit(child) }
      end

      def visit_entity(node)
        type, key, mutability, entity_data, children = node

        if type == "formalist"
          [AST.new(entity_data["form"])]
        else
          []
        end
      end
    end
  end
end
