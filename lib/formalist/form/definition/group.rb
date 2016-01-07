require "formalist/form/definition"
require "formalist/form/result/group"

module Formalist
  class Form
    module Definition
      class Group
        include Definition.with_builders(:attr, :field, :many)

        attr_reader :config

        def initialize(**config, &block)
          @config = config
          yield(self)
        end

        def call(input, errors)
          Result::Group.new(self, input, errors)
        end
      end
    end
  end
end
