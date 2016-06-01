require "formalist/draft_js_html_renderer"

module Formalist
  class DraftJSCompiler

    LIST_ITEM_TYPES = %w(unordered-list-item, ordered-list-item)

    def initialize(renderer)
      @renderer = renderer || DraftJSHTMLRenderer.new
    end

    def call(ast)
      @renderer.list(wrap_lists(ast)) do |node|
        visit(node)
      end
    end

    private

    def visit(node)
      type = node[0]
      content = node[1]
      send(:"visit_#{type}", content)
    end

    def visit_block(data)
      type, key, children = data
      children_wrapped = wrap_lists(children)
      @renderer.block(type, key, children_wrapped) do |child|
        visit(child)
      end
    end

    def visit_inline(data)
      styles, text = data
      @renderer.inline(styles, text)
    end

    def visit_entity(data)
      type, key, _mutability, data, children = data
      children_wrapped = wrap_lists(children)
      @renderer.entity(type, key, data, children_wrapped) do |child|
        visit(child)
      end
    end
  end

  def convert_to_wrapper_node(type, children)
    [
      "wrapper",
      [type, children]
    ]
  end

  def wrap_lists(nodes)
    chunked = ast.chunk do |node|
      node[0] = type
      node[1] = content
      if type == "block"
        content[0] # block type
      else
        type
      end
    end

    output_array = []
    chunked.each do |type, chunk|
      if is_list_item?(type)
        output_array << convert_to_wrapper_node(type, chunk)
      else
        # flatten again by appending chunk onto array.
        output_array = output_array + chunk
      end
    end
    output_array
  end

  def is_list_item?(type)
    LIST_ITEM_TYPES.include?(type)
  end
end

