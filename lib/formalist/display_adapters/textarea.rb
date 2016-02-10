module Formalist
  class DisplayAdapters
    class Textarea
      PERMITTED_TYPES = %w[
        string
      ].freeze

      def call(field)
        raise ArgumentError, "field type must be one of #{PERMITTED_TYPES.join(', ')}" unless PERMITTED_TYPES.include?(field.type)
        field.to_display_variant("textarea")
      end
    end
  end
end
