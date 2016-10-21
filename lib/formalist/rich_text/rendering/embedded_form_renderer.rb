module Formalist
  module RichText
    module Rendering
      class EmbeddedFormRenderer
        attr_reader :container
        attr_reader :render_options

        def initialize(container: {}, render_options: {})
          @container = container
          @render_options = render_options
        end

        def call(form_data)
          type, data = form_data.values_at("name", "data")

          if container.key?(type)
            container[type].(data, render_options)
          else
            ""
          end
        end
      end
    end
  end
end
