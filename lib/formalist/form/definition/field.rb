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
        attr_reader :config

        def initialize(name, type, **config)
          raise ArgumentError, "type +#{type}+ not supported" unless TYPES.include?(type)

          @name = name
          @type = type
          @config = config
        end

        def call(input, errors)
          Result::Field.new(self, input, errors)
        end
      end
    end
  end
end
