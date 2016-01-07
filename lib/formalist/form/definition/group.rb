require "formalist/form/result/group"

module Formalist
  class Form
    module Definition
      class Group
        ALLOWED_CHILDREN = %w[
          attr
          component
          field
          many
        ].freeze

        attr_reader :config, :children

        def initialize(config = {}, children = [])
          unless children.all? { |c| ALLOWED_CHILDREN.include?(Inflecto.underscore(c.class.name).split("/").last) }
            raise ArgumentError, "children must be +#{ALLOWED_CHILDREN.join(', ')}+"
          end

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
