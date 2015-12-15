module Formalist
  class Form
    class Field
      attr_reader :name
      attr_reader :type
      attr_reader :config

      def initialize(name, type, **config)
        @name = name
        @type = type
        @config = config
      end

      def call(input)
        [:field, [name, type, input[name], config.to_a]]
      end
    end
  end
end
