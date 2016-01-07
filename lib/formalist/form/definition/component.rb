require "dry-data"
require "formalist/form/result/component"

module Formalist
  class Form
    module Definition
      class Component
        attr_reader :config
        attr_reader :children

        def initialize(config = {}, children = [])
          @config = config
          @children = children
        end

        def with(new_config = {})
          self.class.new(config.merge(new_config), children)
        end

        def call(input, errors)
          Result::Component.new(self, input, errors)
        end
      end
    end
  end
end
