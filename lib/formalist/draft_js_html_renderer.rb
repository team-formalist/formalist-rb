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
      :block => {
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
        "default" => "p"
      },
      :inline => {
        "bold" => "strong",
        "italic" => "em",
        "strikethrough" => "del",
        "code" => "code",
        "underline" => "u",
        "default" => "span"
      }
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

      if type == 'atomic'
        block_atomic(key, rendered_children)
      else
        render_block_element(type, key, rendered_children)
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
        out = render_inline_element(style, out)
      end
      out
    end

    def entity(type, key, data, children,  &render_child)
      valid_types = %w(link video image default)
      rendered_children = children.map{|child| render_child.call(child)}
      if valid_types.include?(type.downcase)
        send(:"entity_#{type.downcase}", key, data, rendered_children)
      else
        rendered_children
      end
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

    def entity_link(key, data, children)
      result = children
      result.unshift("<a data-entity-key='#{key}' href='#{data[:url]}'>")
      result.push("</a>")
      result.join
    end

    def entity_image(key, data, children)
      "<img data-entity-key='#{key}' src='#{data[:src]}'/>"
    end

    def entity_video(key, data, children)
      "<video data-entity-key='#{key}' src='#{data[:src]}'/>"
    end

    def entity_default(key, data, children)
      result = children
      result.unshift("<div data-entity-key='#{key}'>")
      result.push("</div>")
      result.join
    end


    def render_block_element(type, key, content)
      result = content
      map = ELEMENT_NAME_MAP[:block]
      elem = map[type] || map["default"]
      result.unshift("<#{elem} data-key='#{key}'>")
      result.push("</#{elem}>")
      result.join
    end

    def render_inline_element(type, content)
      result = content
      map = ELEMENT_NAME_MAP[:inline]
      elem = map[type] || map["default"]
      result.unshift("<#{elem}>")
      result.push("</#{elem}>")
      result.join
    end
  end
end