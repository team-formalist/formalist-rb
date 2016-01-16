require "formalist/form/result/section"

module Formalist
  class Form
    module Definition
      class Section
        attr_reader :name
        attr_reader :config
        attr_reader :children

        def initialize(name, config = {}, children = [])
          @name = name
          @config = config
          @children = children
        end

        def call(input, rules, errors)
          Result::Section.new(self, input, rules, errors)
        end
      end
    end
  end
end
