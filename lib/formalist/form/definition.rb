module Formalist
  class Form
    module Definition
      def self.with_builders(*names)
        Module.new do
          def elements
            @__elements__ ||= []
          end

          names.each do |name|
            define_method(name, BuilderMethods.instance_method(name))
          end
        end
      end

      module BuilderMethods
        def attr(name, form: nil, &block)
          elements << Attr.new(name, form: form, &block)
        end

        def field(name, type:, **config)
          elements << Field.new(name, type, config)
        end

        def group(**config, &block)
          elements << Group.new(config, &block)
        end

        def many(name, **config, &block)
          elements << Many.new(name, config, &block)
        end

        def section(name, **config, &block)
          elements << Section.new(name, config, &block)
        end
      end
    end
  end
end

require "formalist/form/attr"
require "formalist/form/field"
require "formalist/form/group"
require "formalist/form/many"
require "formalist/form/section"
