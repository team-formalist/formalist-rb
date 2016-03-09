require "formalist/validation/logic_helpers"

module Formalist
  module Validation
    class ValueRulesCompiler
      include LogicHelpers

      attr_reader :target_name

      def initialize(target_name)
        @target_name = target_name
      end

      def call(ast)
        ast.map { |node| visit(node) }.reduce([], :concat).each_slice(2).to_a
      end

      private

      def visit(node)
        name, nodes = node
        send(:"visit_#{name}", nodes)
      end

      def visit_key(_node)
        # We can ignore "key" checks - we'll only pick up rules for keys we
        # know will exist, since they're attached to fields.
        []
      end

      def visit_val(node)
        name, predicate = node

        # Support names that show as keypaths, e.g. [:reviews, :rating]
        name = name.last if name.is_a?(Array)

        return [] unless name == target_name

        # Skip the "val" prefix

        [:val, [name, visit(predicate)]]
      end

      def visit_predicate(node)
        name, _args = node
        [:predicate, node]
      end

      def visit_and(node)
        left, right = node
        flatten_logical_operation(:and, [visit(left), visit(right)])
      end

      def visit_or(node)
        left, right = node
        flatten_logical_operation(:or, [visit(left), visit(right)])
      end

      def visit_xor(node)
        left, right = node
        flatten_logical_operation(:xor, [visit(left), visit(right)])
      end

      def visit_implication(node)
        left, right = node
        flatten_logical_operation(:implication, [visit(left), visit(right)])
      end

      def method_missing(*)
        []
      end
    end
  end
end
