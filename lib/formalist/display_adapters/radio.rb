module Formalist
  class DisplayAdapters
    class Radio
      PERMITTED_TYPES = %w[
        decimal
        float
        int
        string
      ]

      def call(field)
        raise ArgumentError, "field type must be one of #{PERMITTED_TYPES.join(', ')}" unless PERMITTED_TYPES.include?(field.type)
        raise ArgumentError, "field must have +option_values+ config" unless field.config.keys.include?(:option_values)

        field.to_display_variant("radio")
      end
    end
  end
end
