require "formalist/form/definition"

module Formalist
  class Form
    extend Definition.with_builders(:attr, :field, :group, :many, :section)

    def call(input)
      self.class.elements.map { |el| el.(input) }
    end
  end
end
