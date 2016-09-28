module Formalist
  module RichText
    module Rendering
      class HTMLCompiler
        LIST_ITEM_TYPES = %w(unordered-list-item ordered-list-item)

        attr_reader :html_renderer
        attr_reader :embedded_form_renderer

        def initialize(html_renderer:, embedded_form_renderer:)
          @html_renderer = html_renderer
          @embedded_form_renderer = embedded_form_renderer
        end

        def call(ast)
          html_renderer.nodes(wrap_lists(ast)) do |node|
            visit(node)
          end
        end

        private

        def visit(node)
          type, content = node

          send(:"visit_#{type}", content)
        end

        def visit_block(data)
          type, key, children = data

          html_renderer.block(type, key, wrap_lists(children)) do |child|
            visit(child)
          end
        end

        def visit_wrapper(data)
          type, children = data

          html_renderer.wrapper(type, children) do |child|
            visit(child)
          end
        end

        def visit_inline(data)
          styles, text = data

          html_renderer.inline(styles, text)
        end

        def visit_entity(data)
          type, key, _mutability, data, children = data

          if type == "formalist"
            embedded_form_renderer.(data)
          else
            html_renderer.entity(type, key, data, wrap_lists(children)) do |child|
              visit(child)
            end
          end
        end

        def wrap_lists(nodes)
          chunked = nodes.chunk do |node|
            type, content = node

            if type == "block"
              content[0] # return the block's own type
            else
              type
            end
          end

          chunked.inject([]) { |output, (type, chunk)|
            if list_item?(type)
              output << convert_to_wrapper_node(type, chunk)
            else
              # Flatten again by appending chunk onto array
              output + chunk
            end
          }
        end

        def convert_to_wrapper_node(type, children)
          ["wrapper", [type, children]]
        end

        def list_item?(type)
          LIST_ITEM_TYPES.include?(type)
        end
      end
    end
  end
end
