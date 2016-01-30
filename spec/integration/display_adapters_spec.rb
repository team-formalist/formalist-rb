RSpec.describe "Display adapters" do
  let(:schema) {
    Class.new(Dry::Validation::Schema) do
      key(:temperature_unit)
    end.new
  }

  subject(:form) {
    Class.new(Formalist::Form) do
      field :temperature_unit, type: "string", display: "select", option_values: [%w[c c], %w[f f]]
    end.new(schema)
  }

  it "outputs an AST" do
    expect(form.build({}).to_ast).to eq [
      [:field, [
        :temperature_unit,
        "string",
        "select",
        nil,
        [],
        [],
        [
          [:option_values, [["c", "c"], ["f", "f"]]]
        ]
      ]]
    ]
  end

  it "supports custom disply adapters in a provided container" do
    adapter_class = Class.new do
      def call(field)
        field.to_display_variant("custom")
      end
    end

    container = Class.new(Formalist::DisplayAdapters) do
      register "custom", adapter_class.new
    end

    form = Class.new(Formalist::Form) do
      configure do |config|
        config.display_adapters = container
      end

      field :name, type: "string", display: "custom"
      field :email, type: "string"
    end.new(schema)

    expect(form.build({}).to_ast).to eq [
      [:field, [:name, "string", "custom", nil, [], [], []]],
      [:field, [:email, "string", "default", nil, [], [], []]],
    ]
  end
end
