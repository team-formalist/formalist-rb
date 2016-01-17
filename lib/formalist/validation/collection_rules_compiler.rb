module Formalist
  module Validation
    class CollectionRulesCompiler
      IGNORED_PREDICATES = [:key?].freeze

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

      def visit_set(node)
        name, rules = node
        return [] unless name == target_name

        rules.flatten(1)
      end

      def visit_each(node)
        name, rule = node
        return [] unless name == target_name

        visit(rule)
      end

      # I wonder if I need this here....
      def visit_predicate(node)
        name, args = node
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

      def method_missing(name, *args)
        []
      end

      def flatten_logical_operation(name, contents)
        contents = contents.select(&:any?)

        if contents.length == 0
          []
        elsif contents.length == 1
          contents.first
        else
          [name, contents]
        end
      end
    end
  end
end
