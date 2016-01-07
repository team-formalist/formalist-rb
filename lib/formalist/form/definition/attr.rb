require "formalist/form/definition"
require "formalist/form/result/attr"

module Formalist
  class Form
    module Definition
      class Attr
        include Definition.with_builders(:group, :section, :field)

        attr_reader :name

        def initialize(name, form: nil, &block)
          @name = name
          yield(self)
        end

        def call(input, errors)
          Result::Attr.new(self, input, errors)
        end
      end
    end
  end
end
