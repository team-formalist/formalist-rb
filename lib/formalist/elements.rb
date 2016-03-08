require "dry-container"
require "formalist/elements/attr"
require "formalist/elements/component"
require "formalist/elements/field"
require "formalist/elements/group"
require "formalist/elements/many"
require "formalist/elements/section"

module Formalist
  class Elements
    extend Dry::Container::Mixin

    register :attr, Attr
    register :component, Component
    register :field, Field
    register :group, Group
    register :many, Many
    register :section, Section
  end
end
