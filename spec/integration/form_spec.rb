RSpec.describe Formalist::Form do
  let(:schema) {
    Class.new(Dry::Validation::Schema) do
      key(:title, &:str?)
      key(:rating, &:int?)
    end.new
  }

  subject(:form) {
    Class.new(Formalist::Form) do
      component do |c|
        c.field :title, type: "string"
        c.field :rating, type: "int"
      end
    end.new(schema)
  }

  it "outputs an AST" do
    ast = form.build(title: "Aurora", rating:  10).to_ast

    expect(form.build(title: "Aurora", rating:  10).to_ast).to eq [
      [:component, [
        [],
        [
          [:field, [:title, "string", "default", "Aurora", [[:predicate, [:str?, []]]], [], []]],
          [:field, [:rating, "int", "default", 10, [[:predicate, [:int?, []]]], [], []]]
        ],
      ]],
    ]
  end
end
