module Formalist
  module RichText
    class EmbeddedFormsContainer
      class Registration
        DEFAULT_INPUT_PROCESSOR = -> input { input }.freeze

        attr_reader :label
        attr_reader :form
        attr_reader :schema
        attr_reader :input_processor

        def initialize(label:, form:, schema:, input_processor: DEFAULT_INPUT_PROCESSOR)
          @label = label
          @form = form
          @schema = schema
          @input_processor = input_processor
        end

        def to_h
          {
            label: label,
            form: form,
            schema: schema,
            input_processor: input_processor,
          }
        end
      end
    end
  end
end
