require "dry-data"
require "formalist/form/result/field"

module Formalist
  class Form
    module Definition
      class Field
        TYPES = %w[
          bool
          date
          date_time
          decimal
          float
          int
          string
          time
        ].freeze

        attr_reader :name
        attr_reader :type
        attr_reader :display_variant
        attr_reader :config

        def initialize(name, type, display_variant, config)
          raise ArgumentError, "type +#{type}+ not supported" unless TYPES.include?(type)

          @name = name
          @type = type
          @display_variant = display_variant
          @config = config
        end

        def to_display_variant(display_variant, new_config = {})
          self.class.new(name, type, display_variant, config.merge(new_config))
        end

        def call(input, rules, errors)
          Result::Field.new(self, input, rules, errors)
        end
      end
    end
  end
end
