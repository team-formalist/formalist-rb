require "formalist/draft_js_html_renderer"

module Formalist
  class DraftJSCompiler
    attr_reader render
    LIST_ITEM_TYPES = ["unordered-list-item", "ordered-list-item"]

    def call(ast, renderer)
      @renderer = renderer || DraftJSHTMLRenderer.new
      @renderer.list(chunk_lists(ast)) do |chunk|
        visit_chunk(chunk)
      end
    end

    private

    def visit_chunk(data)
      type, children = data
      if LIST_ITEM_TYPES.include?(type)
        @renderer.wrapper(type, children) do |child|
          visit_node(child)
        end
      else
        @renderer.list(children) do |child|
          visit_node(child)
        end
      end
    end

    def visit_node(node)
      type = node[0]
      content = node[1]
      send(:"visit_#{type}", content)
    end

    def visit_block(data)
      type, key, children = data
      children_chunked = chunked_list(children)
      @renderer.block(type, key, children_chunked) do |child|
        visit_chunk(child)
      end
    end

    def visit_inline(data)
      styles, text = data
      @renderer.inline(styles, text)
    end

    def visit_entity(data)
      type, key, _mutability, data, children = data
      children_chunked = chunked_list(children)
      @renderer.entity(type, key, data, children_chunked) do |child|
        visit_chunk(child)
      end
    end
  end

  def chunk_lists(nodes)
    chunked_array = []
    chunked = ast.chunk do |node|
      node[0] = type
      node[1] = content
      if type == "block"
        content[0]
      else
        type
      end
    end
    chunked.each do |res, chunk|
      chunked_array << [res, chunk]
    end
    chunked_array
  end
end

