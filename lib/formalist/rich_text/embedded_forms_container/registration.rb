module Formalist
  module RichText
    class EmbeddedFormsContainer
      class Registration
        attr_reader :label
        attr_reader :form
        attr_reader :schema

        def initialize(label, form, schema)
          @label = label
          @form = form
          @schema = schema
        end

        def to_h
          {label: label, form: form, schema: schema}
        end
      end
    end
  end
end
