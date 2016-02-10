require "dry-container"
require "formalist/display_adapters/default"
require "formalist/display_adapters/radio"
require "formalist/display_adapters/select"
require "formalist/display_adapters/textarea"

module Formalist
  class DisplayAdapters
    extend Dry::Container::Mixin

    register DEFAULT_DISPLAY_ADAPTER, Default.new
    register "radio", Radio.new
    register "select", Select.new
    register "textarea", Textarea.new
  end
end
