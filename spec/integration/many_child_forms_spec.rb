require "dry/validation/contract"
require "formalist/form"
require "formalist/elements/standard"
require "formalist/rich_text/embedded_forms_container"
# require "formalist/rich_text/embedded_form_compiler"

RSpec.describe Formalist::Form do
  let(:contract) {
    Class.new(Dry::Validation::Contract) do
      schema do
        required(:components).filled(:array)
        required(:test_rich_text).filled(:array)
      end
    end.new
  }

  subject(:form_class) {
    embedded_forms =  Formalist::RichText::EmbeddedFormsContainer.new.tap do |collection|
      collection.register :image_with_caption, label: "Image with caption", form: child_form, schema: child_schema
    end
    Class.new(Formalist::Form) do
      define do
        many_child_forms :components, label: "Components", embeddable_forms: embedded_forms
        rich_text_area :test_rich_text, embeddable_forms: embedded_forms
      end
    end
  }

  let(:child_form) {
    Class.new(Formalist::Form) do
      define do
        field :image_id
        field :caption
      end
    end.new
  }

  let(:child_schema) {
    Class.new(Dry::Validation::Contract) do
      params do
        required(:image_id).filled(:integer)
        required(:caption).filled(:string)
      end
    end.new
  }

  let(:input) {
    {
      title: "Aurora",
      rating: "10",
      components: [
        {
          name: :image_with_caption,
          label: "Image with caption",
          data: {
            image_id: 1234,
            caption: "Cute cat"
          }
        }
      ],
      test_rich_text: [["block", ["unstyled", "b14hd", [["inline", [[], "Some text"]]]]]]
    }
  }

  it "outputs an AST" do
    form = form_class.new.fill(input: input, errors: contract.(input).errors.to_h)
    expect(form.to_ast[0][1][4]).to eq([])
  end
end

