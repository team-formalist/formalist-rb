require "json"
require "dry-logic"
require "formalist/logic/predicates"

RSpec.describe Formalist::Logic::Predicates do
  before do
    module Test
      module Predicates
        include Dry::Logic::Predicates
        import Formalist::Logic::Predicates
      end
    end
  end

  let(:schema) {
    Dry::Validation.Form do
      configure do
        predicates Test::Predicates

        def self.messages
          Dry::Validation::Messages.default.merge(
            en: {errors: {embedded_forms_valid?: "must have valid embedded forms"}}
          )
        end
      end

      required(:body).filled(:embedded_forms_valid?)
    end
  }

  it "supports validating embedded forms within rich text" do
    input = {
      "body" => [
        ["block",["unstyled","b14hd",[["inline",[[],"Before!"]]]]],
        ["block", ["atomic", "48b4f", [["entity", ["formalist", "1", "IMMUTABLE", {:name=>"image_with_caption", :label=>"Image with caption", :data=>{:image_id=>"", :caption=>"Large panda"}, :form=>[[:field, [:image_id, :text_field, "", ["must be filled"], [:object, []]]], [:field, [:caption, :text_field, "Large panda", [], [:object, []]]]]}, [["inline", [[], "¶"]]]]]]]],
        ["block",["unstyled","aivqi",[["inline",[[],"After!"]]]]]
      ].to_json
    }

    result = schema.(input)

    expect(result).to be_failure
    expect(result.messages).to eq(body: ["must have valid embedded forms"])
  end
end
