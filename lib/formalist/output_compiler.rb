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
      name, predicates, errors, children = data

      {name => children.map { |node| visit(node) }.inject(:merge) }
    end

    def visit_field(data)
      name, type, display_variant, value, predicates, errors = data

      {name => coerce(value, type: type)}
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
