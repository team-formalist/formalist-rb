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

      def call(input, errors)
        # errors looks like this
        # {:field_name => [["pages is missing", "another error message"], nil]}
        error_messages = errors[name].to_a[0].to_a

        [:field, [name, type, Dry::Data[type].(input[name]), error_messages, config.to_a]]
      end
    end
  end
end
