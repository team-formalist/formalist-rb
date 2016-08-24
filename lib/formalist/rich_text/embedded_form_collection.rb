require "dry-container"

module Formalist
  module RichText
    class EmbeddedFormCollection
      Registration = Struct.new(:form, :schema)

      attr_reader :container

      def initialize
        @container = Dry::Container.new
      end

      def [](key)
        container[key.to_s]
      end

      def register(key, form, schema = nil)
        container.register(key.to_s, Registration.new(form, schema))
      end

      # TODO: whitelist/blacklist methods to get filtered sets of registrations
    end
  end
end
