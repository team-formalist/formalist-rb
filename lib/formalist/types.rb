require "dry-data"

module Dry
  module Data
    module Predicates
      predicate :respond_to? do |method_name, value|
        value.respond_to?(method_name)
      end
    end
  end
end

module Formalist
  module Types
    Dry::Data.configure { |c| c.namespace = self }
    Dry::Data.finalize

    ElementName = Types::Strict::Symbol.constrained(min_size: 1)

    Dependency = Dry::Data::Type.new(Dry::Data::Type.method(:constructor), primitive: Object)
    Function = Dependency.constrained(respond_to: :call)
  end
end
