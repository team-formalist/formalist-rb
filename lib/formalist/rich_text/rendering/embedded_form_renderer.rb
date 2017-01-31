module Formalist
  module RichText
    module Rendering
      class EmbeddedFormRenderer
        attr_reader :container
        attr_reader :options

        def initialize(container = {}, **options)
          @container = container
          @options = options
        end

        def call(form_data)
          type, data = form_data.values_at(:name, :data)

          if container.key?(type)
            container[type].(data, options)
          else
            ""
          end
        end
      end
    end
  end
end
