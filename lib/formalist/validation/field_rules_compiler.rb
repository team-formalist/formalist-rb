module Formalist
  module Validation
    class FieldRulesCompiler
      IGNORED_PREDICATES = [:key?].freeze

      attr_reader :field_name

      def initialize(field_name)
        @field_name = field_name
      end

      def call(ast)
        ast.map { |node| visit(node) }.reduce(:concat).each_slice(2).to_a
      end

      private

      def visit(node)
        name, nodes = node
        send(:"visit_#{name}", nodes)
      end

      def visit_key(node)
        # We can ignore "key" checks - we'll only pick up rules for keys we
        # know will exist, since they're attached to fields.
        []
      end

      def visit_val(node)
        name, predicate = node
        return [] unless name == field_name

        visit(predicate)
      end

      def visit_predicate(node)
        name, args = node
        return [] if IGNORED_PREDICATES.include?(name)

        node
      end

      def visit_and(node)
        left, right = node
        [visit(left), visit(right)].flatten(1)
      end

      def method_missing(name, *args)
        []
      end
    end
  end
end
