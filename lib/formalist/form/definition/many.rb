require "formalist/form/definition"
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

        include Definition.with_builders(:attr, :group, :field)

        attr_reader :name
        attr_reader :config

        def initialize(name, **config, &block)
          @name = name
          @config = DEFAULT_CONFIG.merge(config)
          yield(self)
        end

        def call(input, errors)
          Result::Many.new(self, input, errors)
        end
      end
    end
  end
end
