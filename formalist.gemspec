lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "formalist/version"

Gem::Specification.new do |spec|
  spec.name           = "formalist"
  spec.version        = Formalist::VERSION
  spec.authors        = ["Tim Riley"]
  spec.email          = ["tim@icelab.com.au"]
  spec.license        = "MIT"

  spec.summary        = "Flexible form builder"
  spec.homepage       = "https://github.com/icelab/formalist"

  spec.files          = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir         = 'exe'
  spec.executables    = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths  = ['lib']

  spec.required_ruby_version = ">= 3.0.0"

  spec.add_runtime_dependency "dry-configurable", "~> 0.7"
  spec.add_runtime_dependency "dry-core", "~> 0.4"
  spec.add_runtime_dependency "dry-container", "~> 0.6"
  spec.add_runtime_dependency "inflecto"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.3.0"
  spec.add_development_dependency "simplecov", "~> 0.13.0"
  spec.add_development_dependency "yard"
end
