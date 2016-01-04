RSpec.describe Formalist::OutputCompiler do
  subject(:compiler) { Formalist::OutputCompiler.new }

  it "works" do
    ast = [
      [:field, [:title, "string", "Aurora", []]],
      [:field, [:rating, "int", "10", []]],
    ]

    expect(compiler.call(ast)).to eq(title: "Aurora", rating: 10)
  end
end
