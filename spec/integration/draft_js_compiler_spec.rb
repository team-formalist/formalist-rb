require "formalist/draft_js_compiler"

RSpec.describe Formalist::DraftJsCompiler do
  subject(:compiler) { Formalist::DraftJsCompiler.new }

  let(:ast) {
    block1 = ["block", ["header-two", "a34sd", [["inline", [[], "Heading"] ] ] ]]
    block2 = ["block", ["unordered-list-item", "dodnk", [["inline", [[], "I am more "] ], ["entity", ["LINK", "3", "MUTABLE", {url: "http://makenosound.com"}, [["inline", [[], "content"] ] ] ] ], ["inline", [[], "."] ] ] ] ]

    [block1, block2, block2, block1]
  }

  it "works" do
    expect(compiler.call(ast)).to_not be_nil
  end


end
