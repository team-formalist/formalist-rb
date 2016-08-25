source "https://rubygems.org"

gemspec

gem "transproc", git: "https://github.com/solnic/transproc", branch: "master"

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem "dry-auto_inject"
  gem "dry-logic"
  gem "dry-validation", ">= 0.8"
end

group :tools do
  gem "pry"
  gem "byebug", platform: :mri
end
