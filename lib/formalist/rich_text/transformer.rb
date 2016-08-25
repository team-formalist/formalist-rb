require "transproc"
require "formalist/rich_text/embedded_form_compiler"

module Formalist
  module RichText

    # - Need to initialize this with the embedded form collection
    # - And then call it with the hash of the form post data
    #
    # I also need to supply a custom transformer, kind of like map_values
    #
    # Usage? Something like this:
    #
    # class MyFormTransformer < Formalist::RichText::Transformer[MyEmbeddedForms]
    #   prepare_rich_text :body
    # end

    class Transformer < Transproc::Transformer
      Undefined = Object.new.freeze

      class << self
        def [](embedded_form_collection)
          Class.new(self).tap do |klass|
            klass.embedded_form_collection embedded_form_collection
          end
        end

        def embedded_form_collection(collection = Undefined)
          if collection == Undefined
            @embedded_form_collection
          else
            @embedded_form_collection = collection
          end
        end

        def embedded_form_compiler
          EmbeddedFormCompiler.new(embedded_form_collection)
        end

        def prepare_rich_text(key)
          transformations << container[:map_value, *[key, embedded_form_compiler]]
        end

        # Go "into" a key and transform some stuff
        def within(key, &block)
          transformations << container[:map_value, *[key], create(container, &block).transproc]
        end
      end
    end
  end
end
