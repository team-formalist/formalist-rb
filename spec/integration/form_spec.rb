RSpec.describe Formalist::Form do
  subject(:form) {
    Class.new(Formalist::Form) do
      field :title, type: :text
      field :description, type: :text
    end.new
  }

  it "outputs an AST" do
    expect(form.(title: "The Martian", description:  "A science fiction novel by Andy Weir.")).to eq [
      [:field, [:title, :text, "The Martian", []]],
      [:field, [:description, :text, "A science fiction novel by Andy Weir.", []]]
    ]
  end
end
