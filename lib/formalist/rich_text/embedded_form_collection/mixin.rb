require "dry-container"
require "formalist/rich_text/embedded_form_collection/registration"

module Formalist
  module RichText
    class EmbeddedFormCollection
      module Mixin
        def self.included(base)
          base.class_eval do
            include ::Dry::Container::Mixin
            include Methods
          end
        end

        def self.extended(base)
          base.class_eval do
            extend ::Dry::Container::Mixin
            extend Methods
          end
        end

        module Methods
          def resolve(key)
            super(key.to_s)
          end

          def register(key, form:, schema:)
            super(key.to_s, Registration.new(form, schema))
          end

          # TODO: methods to return filtered sets of registrations

          def to_h
            keys.each_with_object({}) { |key, output|
              output[key] = self[key].to_h
            }
          end
        end
      end
    end
  end
end
