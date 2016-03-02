require "dry-data"

module Formalist
  module Types
    Dry::Data.configure { |c| c.namespace = self }
    Dry::Data.finalize

    ElementName = Types::Strict::Symbol.constrained(min_size: 1)
  end
end
