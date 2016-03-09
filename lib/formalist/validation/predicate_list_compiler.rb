require "formalist/validation/logic_helpers"

module Formalist
  module Validation
    class PredicateListCompiler
      include LogicHelpers

      IGNORED_PREDICATES = [:key?].freeze

      def call(ast)
        ast.map { |node| visit(node) }.reduce([], :concat).each_slice(2).to_a
      end

      private

      def visit(node)
        name, nodes = node
        send(:"visit_#{name}", nodes)
      end

      def visit_key(node)
        _name, predicate = node

        visit(predicate)
      end

      def visit_val(node)
        _name, predicate = node

        visit(predicate)
      end

      def visit_predicate(node)
        name, _args = node
        return [] if IGNORED_PREDICATES.include?(name)

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
