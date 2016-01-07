module Formalist
  class Form
    class Result
      class Many
        attr_reader :definition, :input, :errors
        attr_reader :children

        def initialize(definition, input, errors)
          @definition = definition
          @input = input.fetch(definition.name, [])
          @errors = errors.fetch(definition.name, [])[0] || []
          @children = build_children
        end

        def to_ary
          local_errors = errors[0].is_a?(String) ? errors : []

          [:many, [definition.name, children.map { |el_list| el_list.map(&:to_ary) }, local_errors, definition.config.to_a]]
        end

        private

        def build_children
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

            definition.children.map { |el| el.(child_input, local_child_errors) }
          }
        end
      end
    end
  end
end
