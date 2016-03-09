require "dry-container"
require "formalist/elements/attr"
require "formalist/elements/compound_field"
require "formalist/elements/field"
require "formalist/elements/group"
require "formalist/elements/many"
require "formalist/elements/section"

module Formalist
  class Elements
    extend Dry::Container::Mixin

    register :attr, Attr
    register :compound_field, CompoundField
    register :field, Field
    register :group, Group
    register :many, Many
    register :section, Section
  end
end
