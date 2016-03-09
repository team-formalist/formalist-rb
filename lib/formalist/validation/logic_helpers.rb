module Formalist
  module Validation
    module LogicHelpers
      def flatten_logical_operation(name, contents)
        contents = contents.select(&:any?)

        if contents.length == 0
          []
        elsif contents.length == 1
          contents.first
        else
          [name, contents]
        end
      end
    end
  end
end
