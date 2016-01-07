require "dry-container"
require "formalist/default_display_adapter"

module Formalist
  class DisplayAdapters
    extend Dry::Container::Mixin

    register "default", DefaultDisplayAdapter.new
  end
end
