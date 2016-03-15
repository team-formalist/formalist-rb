require "dry-auto_inject"
require "formalist/elements/standard"

RSpec.describe "Dependency injection" do
  let(:schema) {
    Dry::Validation.Schema do
      key(:status).required
    end
  }

  subject(:form) {
    Class.new(Formalist::Form) do
      include Test::HashImport["fetch_options"]

      define do
        select_box :status, options: dep(:status_options)
      end

      def status_options
        fetch_options.map { |option| [option, option.capitalize] }
      end
    end.new
  }

  before do
    Test::Container = Class.new do
      extend Dry::Container::Mixin
    end

    Test::Container.register :fetch_options, -> { %w[draft published] }

    auto_inject = Dry::AutoInject(Test::Container)
    Test::HashImport = -> *keys do
      auto_inject.hash[*keys]
    end
  end

  it "supports dependency injection via the initializer's options hash" do
    expect(form.build.to_ast).to eql [
      [:field, [
        :status,
        :select_box,
        nil,
        [],
        [:object, [
          [:options, [:array, [
            [:array, [[:value, ["draft"]], [:value, ["Draft"]]]],
            [:array, [[:value, ["published"]], [:value, ["Published"]]]]
          ]]]
        ]]
      ]]
    ]
  end
end
