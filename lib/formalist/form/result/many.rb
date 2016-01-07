module Formalist
  class Form
    class Result
      class Many
        attr_reader :definition, :input, :errors
        attr_reader :elements

        def initialize(definition, input, errors)
          @definition = definition
          @input = input.fetch(definition.name, [])
          @errors = errors.fetch(definition.name, [])[0] || []
          @elements = build_elements
        end

        def to_ary
          local_errors = errors[0].is_a?(String) ? errors : []

          [:many, [definition.name, elements.map { |el_list| el_list.map(&:to_ary) }, local_errors, definition.config.to_a]]
        end

        private

        def build_elements
          # child errors looks like this:
          # {:links=>
          #   [[{:links=>
          #       [[{:url=>[["url must be filled"], ""]}],
          #        {:name=>"personal", :url=>""}]}],
          #    [{:name=>"company", :url=>"http://icelab.com.au"},
          #     {:name=>"personal", :url=>""}]]}
          #
          # or local errors:
          # {:links=>[["links is missing"], nil]}

          child_errors = errors[0].is_a?(Hash) ? errors : {}

          input.map { |child_input|
            local_child_errors = child_errors.map { |error| error[definition.name] }.detect { |error| error[1] == child_input }.to_a.dig(0, 0) || {}

            definition.elements.map { |el| el.(child_input, local_child_errors) }
          }
        end
      end
    end
  end
end
