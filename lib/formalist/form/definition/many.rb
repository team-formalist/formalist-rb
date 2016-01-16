require "formalist/form/result/many"

module Formalist
  class Form
    module Definition
      class Many
        ALLOWED_CHILDREN = %w[
          attr
          component
          group
          field
        ].freeze

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
          unless children.all? { |c| ALLOWED_CHILDREN.include?(Inflecto.underscore(c.class.name).split("/").last) }
            raise ArgumentError, "children must be +#{ALLOWED_CHILDREN.join(', ')}+"
          end

          @name = name
          @config = DEFAULT_CONFIG.merge(config)
          @children = children
        end

        def call(input, rules, errors)
          Result::Many.new(self, input, rules, errors)
        end
      end
    end
  end
end
