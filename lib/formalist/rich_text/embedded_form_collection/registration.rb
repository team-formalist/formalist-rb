module Formalist
  module RichText
    class EmbeddedFormCollection
      class Registration
        attr_reader :form
        attr_reader :schema

        def initialize(form, schema)
          @form = form
          @schema = schema
        end

        def to_h
          {form: form, schema: schema}
        end
      end
    end
  end
end
