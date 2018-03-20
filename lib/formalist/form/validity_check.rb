module Formalist
  class Form
    class ValidityCheck
      def call(form_ast)
        form_ast.map { |node| visit(node) }.all?
      end
      alias_method :[], :call

      private

      def visit(node)
        name, nodes = node

        send(:"visit_#{name}", nodes)
      end

      def visit_attr(node)
        name, type, errors, attributes, children = node

        errors.empty? && children.map { |child| visit(child) }.all?
      end

      def visit_compound_field(node)
        type, attributes, children = node

        children.map { |child| visit(child) }.all?
      end

      def visit_field(node)
        name, type, input, errors, attributes = node

        errors.empty?
      end

      def visit_group(node)
        type, attributes, children = node

        children.map { |child| visit(child) }.all?
      end

      def visit_many(node)
        name, type, errors, attributes, child_template, children = node

        errors.empty? && children.map { |child| visit(child) }.all?
      end

      def visit_section(node)
        name, type, attributes, children = node

        children.map { |child| visit(child) }.all?
      end
    end
  end
end
