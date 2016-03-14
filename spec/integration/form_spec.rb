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
        compound_field do
          field :title, validate: {filled: true, format: /abc/}
          field :rating
        end
      end
    end.new(schema: schema)
  }

  it "outputs an AST" do
    ast = form.build(title: "Aurora", rating:  10).to_ast

    expect(form.build(title: "Aurora", rating:  10).to_ast).to eq [
      [:compound_field, [
        :compound_field,
        [:object, []],
        [
          [:field, [:title, :field, "Aurora", [], [:object, []]]],
          [:field, [:rating, :field, 10, [], [:object, []]]]
        ],
      ]],
    ]
  end
end
