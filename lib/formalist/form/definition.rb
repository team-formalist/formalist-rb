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

        # This is where we want to pass it through (an optional) display object
        def field(name, type:, display: "default", **config)
          # 1. if there is a `display` provided, find it from a local registry of display objects
          # 2. then pass the `config` through that display object. it'll populate it with more stuff as it requires (including its own "display_variant" name)
          # 3. then pass the fleshed-out config to the field as we do below
          field = Field.new(name, type, config)
          elements << display_adapters[display].call(field)
        end

        # TODO: add a "component" element for wrapping up multiple fields in a custom display adapter
        # We want to _require_ a display object for this
        # def component(display:, **config, &block)
        #   component = Component.new(type, config, &block)
        #   elements << display_adapters[display].call(component)
        # end

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

require "formalist/form/definition/attr"
require "formalist/form/definition/field"
require "formalist/form/definition/group"
require "formalist/form/definition/many"
require "formalist/form/definition/section"
