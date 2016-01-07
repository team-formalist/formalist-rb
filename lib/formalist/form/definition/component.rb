require "dry-data"
require "formalist/form/result/component"

module Formalist
  class Form
    module Definition
      class Component
        ALLOWED_CHILDREN = %w[field].freeze

        attr_reader :config
        attr_reader :children

        def initialize(config = {}, children = [])
          unless children.all? { |c| ALLOWED_CHILDREN.include?(Inflecto.underscore(c.class.name).split("/").last) }
            raise ArgumentError, "children must be +#{ALLOWED_CHILDREN.join(', ')}+"
          end

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
