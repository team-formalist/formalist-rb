require "inflecto"

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
        attr_reader :permitted_children

        def initialize(children)
          @permitted_children = children
        end

        def permitted?(child)
          permitted_children.any? { |permitted_child|
            permitted_child_class = Elements.const_get(Inflecto.camelize(permitted_child))
            child.ancestors.include?(permitted_child_class)
          }
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
