require "formalist/rich_text/html_compiler"

RSpec.describe Formalist::RichText::HTMLCompiler do
  let(:ast) {
    block1 = ["block", ["header-two", "a34sd", [["inline", [[], "Heading"]]]]]
    block2 = ["block", ["unordered-list-item", "dodnk", [["inline", [[], "I am more "]], ["entity", ["LINK", "3", "MUTABLE", {url: "http://makenosound.com"}, [["inline", [[], "content"]]]]], ["inline", [[], "."]]]]]

    [block1, block2, block2, block1]
  }

  describe "with default HTML renderer" do
    let(:compiler) { described_class.new }

    describe "#call" do
      subject(:html) { compiler.(ast) }

      it "compiles to HTML" do
        is_expected.to eq <<-HTML.gsub(/^\s+/, "").gsub("\n", "")
          <h2>Heading</h2>
          <ul>
            <li>I am more <a href='http://makenosound.com'>content</a>.</li>
            <li>I am more <a href='http://makenosound.com'>content</a>.</li>
          </ul>
          <h2>Heading</h2>
        HTML
      end
    end
  end
end
