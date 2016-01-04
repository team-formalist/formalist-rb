require "dry-data"

module Formalist
  class Form
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

      def call(input)
        [:field, [name, type, Dry::Data[type].(input[name]), config.to_a]]
      end
    end
  end
end
