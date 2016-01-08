RSpec.describe Formalist::Form do
  subject(:form) {
    Class.new(Formalist::Form) do
      component do |c|
        c.field :title, type: "string"
        c.field :rating, type: "int"
      end
    end.new
  }

  it "outputs an AST" do
    expect(form.(title: "Aurora", rating:  10).to_ary).to eq [
      [:component, [
        [
          [:field, [:title, "string", "default", "Aurora", [], []]],
          [:field, [:rating, "int", "default", 10, [], []]]
        ],
        []
      ]],
    ]
  end
end
