require "formalist/rich_text/rendering/embedded_form_renderer"

RSpec.describe Formalist::RichText::Rendering::EmbeddedFormRenderer do
  subject(:renderer) { described_class.new(container, namespace: namespace, paths: paths, **options) }

  let(:container) {{
    "article" => -> (*_) { "top_level_article" },
    "embedded_forms.article" => -> (*_) { "namespaced_article" },
    "embedded_forms.newsletter.article" => -> (*_) { "newsletter_article" },
    "embedded_forms.newsletter.components.article" => -> (*_) { "newsletter_components_article" },
    "embedded_forms.general.article" => -> (*_) { "general_article" },
  }}

  let(:options) {
    { render_context: "general" }
  }
  let(:namespace) { nil }
  let(:paths) { [] }

  describe "#call" do
    context "no namespace or paths configured" do
      let(:namespace) { nil }
      let(:paths) { [] }

      it "returns the top level result" do
        expect(renderer.(name: "article")).to eq "top_level_article"
      end
    end


    context "namespace configured" do
      let(:namespace) { "embedded_forms" }
      let(:paths) { [] }

      it "returns the namespaced result" do
        expect(renderer.(name: "article")).to eq "namespaced_article"
      end
    end

    context "namespace and paths configured" do
      let(:namespace) { "embedded_forms" }
      let(:paths) { ["newsletter/components", "newsletter", "general"] }

        it "returns the result in the first path" do
          expect(renderer.(name: "article")).to eq "newsletter_components_article"
        end
    end

    context "key not in paths" do
      let(:namespace) { "embedded_forms" }
      let(:paths) { ["other", "path"] }

      it "returns the result in the namespace" do
        expect(renderer.(name: "article")).to eq "namespaced_article"
      end
    end

    context "key not in namespace" do
      let(:namespace) { "embedded_forms" }
      let(:paths) { ["other", "path"] }
      let(:container) { { "article" => "top_level_article" } }

      it "does not return the result outside the namespace" do
        expect(renderer.(name: "article")).to eq ""
      end
    end
  end

  describe "#with" do
    it "returns an object with options merged" do
      expect(renderer.with(context: "new").options).to eq({render_context: "general", context: "new"})
    end
  end
end