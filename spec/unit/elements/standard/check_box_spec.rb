require "spec_helper"
require "formalist/elements/standard/check_box"

RSpec.describe Formalist::Elements::CheckBox do
  subject(:check_box) {
    Formalist::Elements::CheckBox.new(
      name: :published,
      attributes: attributes,
    ).fill(
      input: {published: input_value},
      errors: errors,
    )
  }

  let(:attributes) { {} }
  let(:errors) { {} }

  describe "input" do
    context "is nil" do
      let(:input_value) { nil }

      specify { expect(check_box.input).to eql false }
    end

    context "is false" do
      let(:input_value) { false }

      specify { expect(check_box.input).to eql false }
    end

    context "is true" do
      let(:input_value) { true }

      specify { expect(check_box.input).to eql true }
    end

    context "is any other value" do
      let(:input_value) { "something" }

      specify { expect(check_box.input).to eql true }
    end
  end
end
