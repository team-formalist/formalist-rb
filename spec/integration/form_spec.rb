RSpec.describe Formalist::Form do
  let(:schema) {
    Class.new(Dry::Validation::Schema) do
      key(:title, &:str?)
      key(:rating, &:int?)
    end.new
  }

  subject(:form) {
    Class.new(Formalist::Form) do
      define do
        component do
          field :title
          field :rating
        end
      end
    end.new(schema: schema)
  }

  it "outputs an AST" do
    ast = form.build(title: "Aurora", rating:  10).to_ast

    expect(form.build(title: "Aurora", rating:  10).to_ast).to eq [
      [:component, [
        :component,
        [],
        [
          [:field, [:title, :field, "Aurora", [[:predicate, [:str?, []]]], [], []]],
          [:field, [:rating, :field, 10, [[:predicate, [:int?, []]]], [], []]]
        ],
      ]],
    ]
  end
end
