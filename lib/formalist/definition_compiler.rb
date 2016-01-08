require "formalist/form/definition/attr"
require "formalist/form/definition/component"
require "formalist/form/definition/field"
require "formalist/form/definition/group"
require "formalist/form/definition/many"
require "formalist/form/definition/section"

module Formalist
  class DefinitionCompiler
    attr_reader :display_adapters

    def initialize(display_adapters)
      @display_adapters = display_adapters
    end

    def call(ast)
      ast.map { |node| visit(node) }
    end

    private

    def visit(node)
      name, attrs = node
      send(:"visit_#{name}", attrs)
    end

    def visit_attr(attrs)
      name, children = attrs
      Form::Definition::Attr.new(name, call(children))
    end

    def visit_component(attrs)
      display, config, children = attrs

      component = Form::Definition::Component.new(config, call(children))
      display_adapters[display].call(component)
    end

    def visit_field(attrs)
      name, type, display, config = attrs

      field = Form::Definition::Field.new(name, type, display, config)
      display_adapters[display].call(field)
    end

    def visit_group(attrs)
      config, children = attrs
      Form::Definition::Group.new(config, call(children))
    end

    def visit_many(attrs)
      name, config, children = attrs
      Form::Definition::Many.new(name, config, call(children))
    end

    def visit_section(attrs)
      name, config, children = attrs
      Form::Definition::Section.new(name, config, call(children))
    end
  end
end
