module Formalist
  class OutputCompiler
    def call(ast)
      ast.map { |node| visit(node) }.inject(:merge)
    end

    private

    def visit(node)
      send(:"visit_#{node[0]}", node[1])
    end

    def visit_attr(data)
      name, predicates, errors, children = data

      {name => children.map { |node| visit(node) }.inject(:merge) }
    end

    def visit_field(data)
      name, _type, _display_variant, value, _predicates, _errors = data

      {name => value.to_s}
    end

    def visit_group(data)
      config, children = data

      children.map { |node| visit(node) }.inject(:merge)
    end

    def visit_many(data)
      name, predicates, errors, config, template, children = data

      {name => children.map { |item| item.map { |node| visit(node) }.inject(:merge) }}
    end

    def visit_section(data)
      name, config, children = data

      children.map { |node| visit(node) }.inject(:merge)
    end
  end
end
