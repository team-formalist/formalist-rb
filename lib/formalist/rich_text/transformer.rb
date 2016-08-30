require "transproc"
require "formalist/rich_text/embedded_form_compiler"

module Formalist
  module RichText
    def self.Transformer(embedded_form_collection, &block)
      Transformer.define(embedded_form_collection, &block)
    end

    class Transformer < Transproc::Transformer
      class << self
        attr_reader :embedded_form_collection

        def define(embedded_form_collection, &block)
          Class.new(self).tap do |klass|
            klass.instance_variable_set :@embedded_form_collection, embedded_form_collection
            klass.instance_exec(&block)
          end.new
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
