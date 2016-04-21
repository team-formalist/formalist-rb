require "spec_helper"
require "formalist/elements/standard/check_box"

RSpec.describe Formalist::Elements::CheckBox do
  subject(:check_box) {
    Formalist::Elements::CheckBox.new(:published, attributes, [], {published: input}, errors)
  }

  let(:attributes) { {} }
  let(:input) { nil }
  let(:errors) { {} }

  describe "input" do
    context "is nil" do
      specify { expect(check_box.input).to eql false }
    end

    context "is false" do
      let(:input) { false }
      specify { expect(check_box.input).to eql false }
    end

    context "is true" do
      let(:input) { true }
      specify { expect(check_box.input).to eql true }
    end

    context "is any other value" do
      let(:input) { "something" }
      specify { expect(check_box.input).to eql true }
    end
  end
end
