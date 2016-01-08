require "dry-container"
require "formalist/display_adapters/default"
require "formalist/display_adapters/select"

module Formalist
  class DisplayAdapters
    extend Dry::Container::Mixin

    register DEFAULT_DISPLAY_ADAPTER, Default.new
    register "select", Select.new
  end
end
