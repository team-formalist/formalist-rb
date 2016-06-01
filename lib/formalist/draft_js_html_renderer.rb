module Formalist
  class DraftJsHtmlRenderer
    # A DraftJS renderer must have the following rendering methods implemented:
    #  1. inline
    #  2. block
    #  3. entity
    #  4. wrapper
    #  5. list

    # block and entity must iterate over the children and yield each of the children back to the compiler

    ELEMENT_NAME_MAP = {
      "header-one" => "h1",
      "header-two" => "h2",
      "header-three" => "h3",
      "header-four" => "h4",
      "header-five" => "h5",
      "header-six" => "h6",
      "unordered-list-item" => "li",
      "ordered-list-item" => "li",
      "unstyled" => "p",
      "blockquote" => "blockquote",
      "code-block" => "pre",
      "bold" => "strong",
      "italic" => "em",
      "strikethrough" => "del",
      "code" => "code",
      "underline" => "u",
      "span" => "span"
    }

    def initialize(options = {})
      @options = options
      options[:allow_empty_tags] ||= false
    end

    # Defines how to handle a list of nodes
    def list(list, &render_child)
      if block_given?
        list.map{|child| render_child.call(child)}.join
      else
        list.join
      end
    end

    # Defines how to handle a block node
    def block(type, key, children, &render_child)
      type_for_method = type.gsub("-", "_")

      rendered_children = children.map{|child| render_child.call(child)}

      if ELEMENT_NAME_MAP.has_key?(type)
        wrap_block_element(type, key, rendered_children)
      else
        send(:"block_#{type_for_method}", key, rendered_children)
      end
    end
     # Defines how to handle a list of blocks with a list type
    def wrapper(type, children, &render_child)
      type_for_method = type.gsub("-", "_")
      rendered_children = children.map{|child| render_child.call(child)}
      send(:"wrapper_#{type_for_method}", rendered_children)
    end

    def inline(styles, content)
      return content if styles.nil? || styles.empty?
      out = content
      styles.each do |style|
        if style == "default" && options[:allow_empty_tags]
          out = content
        else
          style = style == "default" ? "span" : style
          out = wrap_inline_element(style, out)
        end
      end
      out
    end

    def entity(type, key, data, children)
      ""
    end

    private

    def block_atomic(key, children)
      children.join
    end


    def wrapper_unordered_list_item(children)
      result = children
      result.unshift("<ul>")
      result.push("</ul>")
      result.join
    end
    def wrapper_ordered_list_item(children)
      result = children
      result.unshift("<ol>")
      result.push("</ol>")
      result.join
    end

    def wrap_block_element(type, key, content)
      result = content
      elem = ELEMENT_NAME_MAP[type]
      result.unshift("<#{elem} data-key='#{key}'>")
      result.push("</#{elem}>")
      result.join
    end

    def wrap_inline_element(type, content)
      result = content
      elem = ELEMENT_NAME_MAP[type]
      result.unshift("<#{elem}>")
      result.push("</#{elem}>")
      result.join
    end
  end
end