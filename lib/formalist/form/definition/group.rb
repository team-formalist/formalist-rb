require "formalist/form/result/group"

module Formalist
  class Form
    module Definition
      class Group
        attr_reader :config, :children

        def initialize(config = {}, children = [])
          @config = config
          @children = children
        end

        def call(input, errors)
          Result::Group.new(self, input, errors)
        end
      end
    end
  end
end
