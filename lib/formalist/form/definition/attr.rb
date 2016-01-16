require "formalist/form/result/attr"

module Formalist
  class Form
    module Definition
      class Attr
        attr_reader :name, :children

        def initialize(name, children)
          @name = name
          @children = children
        end

        def call(input, rules, errors)
          Result::Attr.new(self, input, rules, errors)
        end
      end
    end
  end
end
