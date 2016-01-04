RSpec.describe Formalist::Form do
  subject(:form) {
    Class.new(Formalist::Form) do
      field :title, type: "string"
      field :rating, type: "int"
    end.new
  }

  it "outputs an AST" do
    expect(form.(title: "Aurora", rating:  10)).to eq [
      [:field, [:title, "string", "Aurora", []]],
      [:field, [:rating, "int", 10, []]]
    ]
  end
end
