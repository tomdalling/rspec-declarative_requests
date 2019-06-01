# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/declarative_requests/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-declarative_requests"
  spec.version       = RSpec::DeclarativeRequests::VERSION
  spec.authors       = ["Tom Dalling"]
  spec.email         = ["tom" + "@" + "tomdalling.com"]

  spec.summary       = %q{A standardized structure for request specs}
  spec.description   = %q{A standardized structure for request specs}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rails", "~> 5.2"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency 'gem-release'
end
