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
      define do
        select_box :status, options: status_options
      end

      attr_reader :status_repo

      def initialize(status_repo:, **args)
        @status_repo = status_repo
        super(**args)
      end

      def status_options
        status_repo.statuses.map { |status| [status, status.capitalize] }
      end
    end.new(status_repo: status_repo)
  }

  let(:status_repo) {
    Class.new do
      def statuses
        %w[draft published]
      end
    end.new
  }

  it "supports dependency injection via the initializer's options hash" do
    expect(form.to_ast).to eql [
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
