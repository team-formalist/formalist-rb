require "dry-container"
require "formalist/rich_text/embedded_forms_container/registration"

module Formalist
  module RichText
    class EmbeddedFormsContainer
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

          def register(key, **attrs)
            super(key.to_s, Registration.new(**attrs))
          end

          def to_h
            keys.each_with_object({}) { |key, output|
              output[key] = self[key].to_h
            }
          end

          # TODO: methods to return filtered sets of registrations
        end
      end
    end
  end
end
