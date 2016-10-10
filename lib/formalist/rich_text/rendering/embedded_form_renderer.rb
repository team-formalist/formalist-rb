module Formalist
  module RichText
    module Rendering
      class EmbeddedFormRenderer
        attr_reader :container

        def initialize(container = {})
          @container = container
        end

        def call(form_data)
          if container.key?(form_data["name"])
            container[form_data["name"]].(form_data["data"])
          else
            ""
          end
        end
      end
    end
  end
end
