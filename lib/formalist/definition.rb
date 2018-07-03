module Formalist
  class Definition
    DuplicateElementError = Class.new(StandardError)

    attr_reader :form
    attr_reader :config
    attr_reader :elements

    def initialize(form, config, &block)
      @form = form
      @config = config
      @elements = []

      instance_eval(&block) if block
    end

    def with(**new_options, &block)
      new_config = new_options.each_with_object(config.dup) { |(key, value), config|
        config.send :"#{key}=", value
      }

      self.class.new(form, new_config, &block)
    end

    def method_missing(name, *args, &block)
      if element_type?(name)
        add_element(name, *args, &block)
      elsif form.respond_to?(name, include_private = true)
        form.send(name, *args, &block)
      else
        super
      end
    end

    private

    def respond_to_missing?(name, _include_private = false)
      element_type?(name) || form.respond_to?(name, _include_private = true) || super
    end

    def element_type?(type)
      config.elements_container.key?(type)
    end

    def add_element(type, *args, &block)
      element_name = args.shift unless args.first.is_a?(Hash)
      element_attrs = args.last.is_a?(Hash) ? args.last : {}

      if element_name && elements.any? { |element| element.name == element_name }
        raise DuplicateElementError, "element +#{element_name}+ is already defined in this context"
      end

      element_class = config.elements_container[type]
      element_children = with(&block).elements

      element = element_class.build(
        name: element_name,
        attributes: element_attrs,
        children: element_children,
      )

      elements << element
    end
  end
end
