module Formalist
  class OutputCompiler
    def call(ast)
      ast.map { |node| visit(node) }.inject(:merge)
    end

    private

    def visit(node)
      __send__(:"visit_#{node[0]}", node[1])
    end

    def visit_attr(data)
    end

    def visit_field(data)
      name, _type, value = data

      {name => value}
    end

    def visit_group(data)
    end

    def visit_many(data)
    end

    def visit_section(data)
    end
  end
end
