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
        _name, _type, errors, _attributes, children = node

        errors.empty? && children.map { |child| visit(child) }.all?
      end

      def visit_compound_field(node)
        _type, _attributes, children = node

        children.map { |child| visit(child) }.all?
      end

      def visit_field(node)
        _name, _type, _input, errors, _attributes = node

        errors.empty?
      end

      def visit_group(node)
        _type, _attributes, children = node

        children.map { |child| visit(child) }.all?
      end

      def visit_many(node)
        _name, _type, errors, _attributes, _child_template, children = node

        # The `children`` parameter for `many` elements is for some reason
        # doubly nested right now, so we need to flatten it.
        errors.empty? && children.flatten(1).map { |child| visit(child) }.all?
      end

      def visit_section(node)
        _name, _type, _attributes, children = node

        children.map { |child| visit(child) }.all?
      end
    end
  end
end
