require "formalist/form/definition"
require "formalist/form/result/section"

module Formalist
  class Form
    module Definition
      class Section
        include Definition.with_builders(:attr, :field, :group, :many, :section)

        attr_reader :name
        attr_reader :config

        def initialize(name, **config, &block)
          @name = name
          @config = config
          yield(self)
        end

        def call(input, errors)
          Result::Section.new(self, input, errors)
        end
      end
    end
  end
end
