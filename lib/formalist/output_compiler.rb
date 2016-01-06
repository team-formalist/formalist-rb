require "dry-data"

module Formalist
  class OutputCompiler
    FORM_TYPES = %w[
      bool
      date
      date_time
      decimal
      float
      int
      time
    ].freeze

    def call(ast)
      ast.map { |node| visit(node) }.inject(:merge)
    end

    private

    def visit(node)
      send(:"visit_#{node[0]}", node[1])
    end

    def visit_attr(data)
      name, elements, _errors = data

      {name => elements.map { |node| visit(node) }.inject(:merge) }
    end

    def visit_field(data)
      name, type, value, _errors = data

      {name => coerce(value, type: type)}
    end

    def visit_group(data)
      elements, _config = data

      elements.map { |node| visit(node) }.inject(:merge)
    end

    def visit_many(data)
      name, elements, _errors, _config = data

      {name => elements.map { |item| item.map { |node| visit(node) }.inject(:merge) }}
    end

    def visit_section(data)
      _name, elements, _config = data

      elements.map { |node| visit(node) }.inject(:merge)
    end

    private

    def coerce(value, type:)
      if FORM_TYPES.include?(type)
        Dry::Data["form.#{type}"].(value)
      else
        Dry::Data[type].(value)
      end
    end
  end
end
