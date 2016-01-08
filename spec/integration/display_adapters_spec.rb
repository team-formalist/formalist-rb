RSpec.describe "Display adapters" do
  subject(:form) {
    Class.new(Formalist::Form) do
      field :temperature_unit, type: "string", display: "select", option_values: [%w[c c], %w[f f]]
    end.new
  }

  it "outputs an AST" do
    expect(form.({}).to_ary).to eq [
      [:field, [
        :temperature_unit,
        "string",
        "select",
        nil,
        [],
        [
          [:option_values, [["c", "c"], ["f", "f"]]]
        ]
      ]]
    ]
  end
end
