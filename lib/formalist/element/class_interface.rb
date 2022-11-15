require "dry-inflector"

module Formalist
  class Element
    # Class-level API for form elements.
    module ClassInterface
      def type
        inflector = Dry::Inflector.new
        inflector.underscore(inflector.demodulize(name)).to_sym
      end

      def attribute(name, default: nil)
        attributes(name => {default: default})
      end

      def attributes_schema
        super_schema = superclass.respond_to?(:attributes_schema) ? superclass.attributes_schema : {}
        super_schema.merge(@attributes_schema || {})
      end

      private

      def attributes(new_schema)
        prev_schema = @attributes_schema || {}
        @attributes_schema = prev_schema.merge(new_schema)

        self
      end
    end
  end
end
