RSpec.describe Formalist::Form do
  let(:schema) {
    Dry::Validation.Schema do
      required(:title).filled
      required(:rating).filled(:int?)

      required(:reviews).each do
        required(:summary).filled
        required(:rating).filled(:int?, gteq?: 1, lteq?: 10)
      end

      required(:meta).schema do
        required(:pages).filled(:int?, gteq?: 1)
      end
    end
  }

  subject(:form) {
    Class.new(Formalist::Form) do
      define do
        compound_field do
          field :title, validate: {filled: true}
          field :rating, validate: {filled: true}
        end

        many :reviews do
          field :summary, validate: {filled: true}
          field :rating, validate: {filled: true}
        end

        attr :meta do
          field :pages, validate: {filled: true}
        end
      end
    end.new
  }

  it "outputs an AST" do
    input = {
      title: "Aurora",
      rating: "10",
      reviews: [
        {
          summary: "",
          rating: 10
        },
        {
          summary: "Great!",
          rating: 0
        }
      ],
      meta: {
        pages: 0
      }
    }

    result = schema.(input)

    expect(form.build(result.output, result.messages).to_ast).to eq [
      [:compound_field, [
        :compound_field,
        [:object, []],
        [
          [:field, [:title, :field, "Aurora", [], [:object, []]]],
          [:field, [:rating, :field, "10", ["must be an integer"], [:object, []]]]
        ]
      ]],
      [:many, [
        :reviews,
        :many,
        [],
        [:object, [
          [:allow_create, [:value, [true]]],
          [:allow_update, [:value, [true]]],
          [:allow_destroy, [:value, [true]]],
          [:allow_reorder, [:value, [true]]]
        ]],
        [
          [:field, [:summary, :field, nil, [], [:object, []]]],
          [:field, [:rating, :field, nil, [], [:object, []]]]
        ],
        [
          [
            [:field, [:summary, :field, "", ["must be filled"], [:object, []]]],
            [:field, [:rating, :field, 10, [], [:object, []]]]
          ],
          [
            [:field, [:summary, :field, "Great!", [], [:object, []]]],
            [:field, [:rating, :field, 0, ["must be greater than or equal to 1", "must be less than or equal to 10"], [:object, []]]]
          ]
        ]
      ]],
      [:attr, [
        :meta,
        :attr,
        [],
        [:object, []],
        [
          [:field, [:pages, :field, 0, ["must be greater than or equal to 1"], [:object, []]]]
        ]
      ]]
    ]
  end
end
