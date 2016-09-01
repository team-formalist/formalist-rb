require "formalist/elements/standard"
require "formalist/form/validity_check"

RSpec.describe Formalist::Form::ValidityCheck do
  subject(:check) { described_class.new }

  subject(:form_ast) {
    form = Class.new(Formalist::Form) do
      define do
        text_field :title
      end
    end.new.build(input, errors).to_ast
  }

  describe "#call" do
    subject(:result) { check.(form_ast) }

    context "valid form" do
      let(:input) {
        {title: "The Martian"}
      }

      let(:errors) { {} }

      it { is_expected.to be true }
    end

    context "invalid form" do
      let(:input) {
        {title: "The Martian"}
      }

      let(:errors) {
        {title: ["Must be Terran"]}
      }

      it { is_expected.to be false }
    end
  end
end
