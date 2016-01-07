RSpec.describe Formalist::OutputCompiler do
  subject(:compiler) { Formalist::OutputCompiler.new }

  let(:form) {
    Class.new(Formalist::Form) do
      field :title, type: "string"
      field :rating, type: "int"

      many :reviews do |review|
        review.field :description, type: "string"
        review.field :rating, type: "int"
      end

      attr :meta do |meta|
        meta.section "Metadata" do |section|
          section.group do |group|
            group.field :pages, type: "int"
            group.field :publisher, type: "string"
          end
        end
      end
    end.new
  }

  let(:input) {
    {
      title: "Aurora",
      rating: 10,
      reviews: [
        {
          description: "Wonderful",
          rating: 10,
        },
        {
          description: "Enchanting",
          rating: 9,
        }
      ],
      meta: {
        pages: 321,
        publisher: "Orbit",
      },
    }
  }

  let(:ast) { form.call(input).to_ary }

  it "works" do
    expect(compiler.call(ast)).to eq input
  end
end
