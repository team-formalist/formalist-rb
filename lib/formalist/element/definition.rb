require "dry-data"

module Formalist
  class Element
    class Definition
      def self.build(type, attributes, children)
        # Sanitize attributes here to provide early feedback to the users
        attributes = Dry::Data["hash"].schema(type.schema).(attributes)

        new(type, attributes, children)
      end

      attr_reader :type
      attr_reader :attributes
      attr_reader :children

      def initialize(type, attributes, children)
        @type = type
        @attributes = attributes
        @children = children
      end

      def call(input, rules, messages)
        type.(attributes, children, input, rules, messages)
      end
    end
  end
end
