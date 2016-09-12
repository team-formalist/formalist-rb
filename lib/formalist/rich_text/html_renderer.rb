module Formalist
  module RichText
    class HTMLRenderer
      # A DraftJS HTML renderer must have the following rendering methods implemented:
      #  1. inline
      #  2. block
      #  3. entity
      #  4. wrapper
      #  5. nodes

      # block and entity must iterate over the children and yield each of the children back to the compiler

      BLOCK_ELEMENTS_MAP = {
        "header-one" => "h1",
        "header-two" => "h2",
        "header-three" => "h3",
        "header-four" => "h4",
        "header-five" => "h5",
        "header-six" => "h6",
        "unordered-list-item" => "li",
        "ordered-list-item" => "li",
        "blockquote" => "blockquote",
        "code-block" => "pre",
      }.freeze

      DEFAULT_BLOCK_ELEMENT = "p".freeze

      INLINE_ELEMENTS_MAP = {
        "bold" => "strong",
        "italic" => "em",
        "strikethrough" => "del",
        "code" => "code",
        "underline" => "u",
      }

      DEFAULT_INLINE_ELEMENT = "span".freeze

      def initialize(options = {})
        @options = options
      end

      # Defines how to handle a list of nodes
      def nodes(nodes)
        nodes = nodes.map { |node| yield(node) } if block_given?
        nodes.join
      end

      # Defines how to handle a block node
      def block(type, key, children)
        rendered_children = children.map { |child| yield(child) }

        if type == 'atomic'
          block_atomic(key, rendered_children)
        else
          render_block_element(type, rendered_children)
        end
      end

       # Defines how to handle a list of blocks with a list type
      def wrapper(type, children)
        type_for_method = type.gsub("-", "_")

        rendered_children = children.map { |child| yield(child) }

        send(:"wrapper_#{type_for_method}", rendered_children)
      end

      def inline(styles, content)
        return content if styles.nil? || styles.empty?
        out = content
        styles.each do |style|
          out = render_inline_element(style, out)
        end
        out
      end

      def entity(type, key, data, children)
        valid_types = %w(link video image default)

        rendered_children = children.map { |child| yield(child) }

        if valid_types.include?(type.downcase)
          send(:"entity_#{type.downcase}", data, rendered_children)
        else
          rendered_children
        end
      end

      private

      def block_atomic(key, children)
        children.join
      end

      def wrapper_unordered_list_item(children)
        html_tag(:ul) do
          children.join
        end
      end

      def wrapper_ordered_list_item(children)
        html_tag(:ol) do
          children.join
        end
      end

      def entity_link(data, children)
        html_tag(:a, href: data[:url]) do
          children.join
        end
      end

      def entity_image(data, children)
        html_tag(:img, src: data[:src])
      end

      def entity_video(data, children)
         html_tag(:video, src: data[:src])
      end

      def entity_default(attrs, children)
        html_tag(:div, attrs) do
          children.join
        end
      end

      def render_block_element(type, content)
        elem = BLOCK_ELEMENTS_MAP.fetch(type.downcase, DEFAULT_BLOCK_ELEMENT)

        html_tag(elem) do
          if content.is_a?(Array)
            content.join
          else
            content
          end
        end
      end

      def render_inline_element(type, content)
        elem = INLINE_ELEMENTS_MAP.fetch(type.downcase, DEFAULT_INLINE_ELEMENT)

        html_tag(elem) do
          if content.is_a?(Array)
            content.join
          else
            content
          end
        end
      end

      def html_tag(tag, options = {})
        options_string = html_options_string(options)
        out = "<#{tag} #{options_string}".strip

        content = block_given? ? yield : ""

        if content.nil? || content.empty?
          out << "/>"
        else
          out << ">#{content}</#{tag}>"
        end
      end

      def html_options_string(options)
        opts = options.map do |key, val|
          "#{key}='#{val}'"
        end
        opts.join(" ")
      end
    end
  end
end
