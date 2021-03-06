# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/declarative_requests/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-declarative_requests"
  spec.version       = RSpec::DeclarativeRequests::VERSION
  spec.authors       = ["Tom Dalling"]
  spec.email         = ["tom" + "@" + "tomdalling.com"]

  spec.summary       = %q{A standardized structure for request specs in Rails.}
  spec.description   = %q{A standardized structure for request specs in Rails.}
  spec.homepage      = 'https://github.com/tomdalling/rspec-declarative_requests'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", "~> 5.0"
  spec.add_runtime_dependency "rspec-rails", ">= 0"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency 'rspec-composable_json_matchers'
  spec.add_development_dependency "byebug"
  spec.add_development_dependency 'gem-release'
end
