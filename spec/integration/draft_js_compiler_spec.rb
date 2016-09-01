require "formalist/draft_js_compiler"

RSpec.describe Formalist::DraftJsCompiler do
  subject(:compiler) { Formalist::DraftJsCompiler.new }

  let(:ast) {
    block1 = ["block", ["header-two", "a34sd", [["inline", [[], "Heading"] ] ] ]]
    block2 = ["block", ["unordered-list-item", "dodnk", [["inline", [[], "I am more "] ], ["entity", ["LINK", "3", "MUTABLE", {url: "http://makenosound.com"}, [["inline", [[], "content"] ] ] ] ], ["inline", [[], "."] ] ] ] ]

    [block1, block2, block2, block1]
  }

  let(:output_html) {
    "<h2 data-key='a34sd'>Heading</h2><ul><li data-key='dodnk'>I am more <a data-entity-key='3' href='http://makenosound.com'>content</a>.</li><li data-key='dodnk'>I am more <a data-entity-key='3' href='http://makenosound.com'>content</a>.</li></ul><h2 data-key='a34sd'>Heading</h2>"
  }

  it "works" do
    expect(compiler.call(ast)).to eq(output_html)
  end


end
