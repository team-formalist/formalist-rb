module Formalist
  class Form
    class Result
      class Many
        attr_reader :definition, :input, :errors

        def initialize(definition, input, errors)
          @definition = definition
          @input = input
          @errors = errors.fetch(definition.name, [])[0] || []
        end

        def to_ary
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

          local_errors = errors[0].is_a?(String) ? errors : []
          child_errors = errors[0].is_a?(Hash) ? errors : {}

          children = input[definition.name].to_a.map { |child_input|
            local_child_errors = child_errors.map { |error| error[definition.name] }.detect { |error| error[1] == child_input }.to_a.dig(0, 0) || {}

            definition.elements.map { |el| el.(child_input, local_child_errors).to_ary }
          }

          [:many, [definition.name, children, local_errors, definition.config.to_a]]
        end
      end
    end
  end
end
