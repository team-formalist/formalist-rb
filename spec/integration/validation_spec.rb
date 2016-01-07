require "dry-validation"
require "pp"

RSpec.describe "Form validation" do
  subject(:schema) {
    Class.new(Dry::Validation::Schema) do
      key(:title) { |title| title.filled? }
      key(:rating) { |rating| rating.gteq?(1) & rating.lteq?(10) }

      key(:reviews) do |reviews|
        reviews.array? do
          reviews.each do |review|
            review.hash? do
              review.key(:summary) { |summary| summary.filled? }
              review.key(:rating) { |rating| rating.gteq?(1) & rating.lteq?(10) }
            end
          end
        end
      end

      key(:meta) do |meta|
        meta.key(:pages) { |pages| pages.filled? }
      end
    end.new
  }

  subject(:form) {
    Class.new(Formalist::Form) do
      field :title, type: "string"
      field :rating, type: "int"

      many :reviews do |review|
        review.field :summary, type: "string"
        review.field :rating, type: "int"
      end

      attr :meta do |meta|
        meta.field :pages, type: "int"
      end
    end.new(schema: schema)
  }

  it "includes validation errors in the AST" do
    input = {
      reviews: [{summary: "Great", rating: 0}, {summary: "", rating: 1}],
      meta: {pages: nil}
    }

    expect(form.call(input).to_ary).to eq [
      [:field, [:title, "string", nil, ["title is missing"], []]],
      [:field, [:rating, "int", nil, ["rating is missing", "rating must be greater than or equal to 1", "rating must be less than or equal to 10"], []]],
      [:many, [:reviews,
        [
          [
            [:field, [:summary, "string", "Great", [], []]],
            [:field, [:rating, "int", 0, ["rating must be greater than or equal to 1"], []]]
          ],
          [
            [:field, [:summary, "string", "", ["summary must be filled"], []]],
            [:field, [:rating, "int", 1, [], []]]
          ]
        ],
        [],
        [
          [:allow_create, true],
          [:allow_update, true],
          [:allow_destroy, true],
          [:allow_reorder, true]
        ]
      ]],
      [:attr, [:meta,
        [
          [:field, [:pages, "int", nil, ["pages must be filled"], []]]
        ],
        []
      ]]
    ]
  end

  it "includes validation errors on container elements (attr and many)" do
    input = {}

    expect(form.call(input).to_ary).to eq [
      [:field, [:title, "string", nil, ["title is missing"], []]],
      [:field, [:rating, "int", nil, ["rating is missing", "rating must be greater than or equal to 1", "rating must be less than or equal to 10"], []]],
      [:many, [:reviews, [], ["reviews is missing"],
        [
          [:allow_create, true],
          [:allow_update, true],
          [:allow_destroy, true],
          [:allow_reorder, true]
        ]
      ]],
      [:attr, [:meta,
        [
          [:field, [:pages, "int", nil, [], []]]
        ],
        ["meta is missing"]
      ]]
    ]
  end
end
