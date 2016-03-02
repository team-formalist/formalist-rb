module Formalist
  class Element
    class PermittedChildren
      All = Class.new do
        def permitted?(*)
          true
        end
      end.new

      None = Class.new do
        def permitted?(*)
          false
        end
      end.new

      class Some
        attr_reader :children
        def initialize(children)
          @children = children
        end

        def permitted?(child)
          children.include?(child)
        end
      end

      def self.all
        All
      end

      def self.none
        None
      end

      def self.[](children)
        Some.new(children)
      end
    end
  end
end
