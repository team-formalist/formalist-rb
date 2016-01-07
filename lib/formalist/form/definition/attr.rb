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

        def call(input, errors)
          Result::Attr.new(self, input, errors)
        end
      end
    end
  end
end
