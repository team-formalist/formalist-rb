require "formalist/rich_text/validity_check"

RSpec.describe Formalist::RichText::ValidityCheck do
  subject(:check) { described_class.new }

  describe "#call" do
    subject(:result) { check.(input) }

    context "embedded form valid" do
      let(:input) {
        [
          ["block",["unstyled","b14hd",[["inline",[[],"Before!"]]]]],
          ["block", ["atomic", "48b4f", [["entity", ["formalist", "1", "IMMUTABLE", {"name"=>"image_with_caption", "label"=>"Image with caption", "data"=>{"image_id"=>"5678", "caption"=>"Large panda"}, "form"=>[[:field, [:image_id, :text_field, 5678, [], [:object, []]]], [:field, [:caption, :text_field, "Large panda", [], [:object, []]]]]}, [["inline", [[], "¶"]]]]]]]],
          ["block",["unstyled","aivqi",[["inline",[[],"After!"]]]]]
        ]
      }

      it { is_expected.to be true }
    end

    context "embedded form invalid" do
      let(:input) {
        [
          ["block",["unstyled","b14hd",[["inline",[[],"Before!"]]]]],
          ["block", ["atomic", "48b4f", [["entity", ["formalist", "1", "IMMUTABLE", {"name"=>"image_with_caption", "label"=>"Image with caption", "data"=>{"image_id"=>"", "caption"=>"Large panda"}, "form"=>[[:field, [:image_id, :text_field, nil, ["must be filled"], [:object, []]]], [:field, [:caption, :text_field, "Large panda", [], [:object, []]]]]}, [["inline", [[], "¶"]]]]]]]],
          ["block",["unstyled","aivqi",[["inline",[[],"After!"]]]]]
        ]
      }

      it { is_expected.to be false }
    end
  end
end
