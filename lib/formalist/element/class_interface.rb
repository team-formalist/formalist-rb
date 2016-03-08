require "inflecto"
require "formalist/element/permitted_children"

module Formalist
  class Element
    module ClassInterface
      def type
        Inflecto.underscore(Inflecto.demodulize(name)).to_sym
      end

      def attribute(name, type, default: nil)
        attributes(name => {type: type, default: default})
      end

      def attributes(new_schema)
        prev_schema = schema || {}
        @schema = prev_schema.merge(new_schema)

        self
      end

      def schema
        super_schema = superclass.respond_to?(:schema) ? superclass.schema : {}
        super_schema.merge(@schema || {})
      end

      def permitted_children(*args)
        return @permitted_children ||= PermittedChildren.all if args.empty?

        @permitted_children = if %i[all none].include?(args.first)
          PermittedChildren.send(args.first)
        else
          PermittedChildren[args]
        end
      end
    end
  end
end
