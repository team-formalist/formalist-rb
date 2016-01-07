require "formalist/form/result/many"

module Formalist
  class Form
    module Definition
      class Many
        DEFAULT_CONFIG = {
          allow_create: true,
          allow_update: true,
          allow_destroy: true,
          allow_reorder: true
        }.freeze

        attr_reader :name
        attr_reader :config
        attr_reader :children

        def initialize(name, config = {}, children = [])
          @name = name
          @config = DEFAULT_CONFIG.merge(config)
          @children = children
        end

        def call(input, errors)
          Result::Many.new(self, input, errors)
        end
      end
    end
  end
end
