RSpec.describe Formalist::OutputCompiler do
  subject(:compiler) { Formalist::OutputCompiler.new }

  it "works" do
    ast = [
      [:field, [:title, :text, "The Martian", []]],
      [:field, [:description, :text, "A science fiction novel by Andy Weir.", []]]
    ]

    expect(compiler.call(ast)).to eq(title: "The Martian", description:  "A science fiction novel by Andy Weir.")
  end
end
