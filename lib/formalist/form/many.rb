require "formalist/form/definition"

module Formalist
  class Form
    class Many
      DEFAULT_CONFIG = {
        allow_create: true,
        allow_update: true,
        allow_destroy: true,
        allow_reorder: true
      }.freeze

      include Definition.with_builders(:attr, :group, :field)

      attr_reader :name
      attr_reader :config

      def initialize(name, **config, &block)
        @name = name
        @config = DEFAULT_CONFIG.merge(config)
        yield(self)
      end

      def call(input, errors)
        # errors looks like this:
        # {:links=>
        #   [[{:links=>
        #       [[{:url=>[["url must be filled"], ""]}],
        #        {:name=>"personal", :url=>""}]}],
        #    [{:name=>"company", :url=>"http://icelab.com.au"},
        #     {:name=>"personal", :url=>""}]]}

        errors = errors.fetch(name, [])[0]
        local_errors = errors[0].is_a?(Hash) ? [] : errors
        child_errors = errors[0].is_a?(Hash) ? errors[0] : {}

        children = input[name].to_a.map { |child_input|
          child_error_messages = error_messages.detect { |msg| msg[1] == child_input }[0][0]

          elements.map { |el| el.(child_input, child_errors) }
        }

        [:many, [name, children, local_errors, config.to_a]]
      end
    end
  end
end
