require "formalist/rich_text/rendering/embedded_form_renderer"

RSpec.describe Formalist::RichText::Rendering::EmbeddedFormRenderer do
  subject(:renderer) { described_class.new(container, namespace: namespace, paths: paths) }

  let(:container) {{
    "article" => "top_level_article",
    "embedded_forms.article" => "namespaced_article",
    "embedded_forms.newsletter.article" => "newsletter_article",
    "embedded_forms.newsletter.components.article" => "newsletter_components_article",
    "embedded_forms.general.article" => "general_article",
   }}

  context "no namespace or paths configured" do
    let(:namespace) { nil }
    let(:paths) { [] }

    describe "#resolve_key" do
      it "returns the top level result" do
        expect(renderer.send(:resolve_key, "article")).to eq "article"
      end
    end
  end

  context "namespace configured" do
    let(:namespace) { "embedded_forms" }
    let(:paths) { [] }

    describe "#resolve_key" do
      it "returns the namespaced result" do
        expect(renderer.send(:resolve_key, "article")).to eq "embedded_forms.article"
      end
    end
  end

  context "namespace and paths configured" do
    let(:namespace) { "embedded_forms" }
    let(:paths) { ["newsletter/components", "newsletter", "general"] }

    describe "#resolve_key" do
      it "returns the result in the first path" do
        expect(renderer.send(:resolve_key, "article")).to eq "embedded_forms.newsletter.components.article"
      end
    end
  end

  context "key not in paths" do
    let(:namespace) { "embedded_forms" }
    let(:paths) { ["other", "path"] }

    describe "#resolve_key" do
      it "returns the result in the namespace" do
        expect(renderer.send(:resolve_key, "article")).to eq "embedded_forms.article"
      end
    end
  end

  context "key not in namespace" do
    let(:namespace) { "embedded_forms" }
    let(:paths) { ["other", "path"] }
    let(:container) {{
      "article" => "top_level_article"
     }}

    describe "#resolve_key" do
      it "does not return the result outside the namespace" do
        expect(renderer.send(:resolve_key, "article")).to eq nil
      end
    end
  end
end