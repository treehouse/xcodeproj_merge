# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xcodeproj_merge/version'

Gem::Specification.new do |spec|
  spec.name          = "xcodeproj_merge"
  spec.version       = XcodeprojMerge::VERSION
  spec.authors       = ["Milo Winningham"]
  spec.email         = ["milo@winningham.net"]

  spec.summary       = %q{Copies file references from one Xcode project to another.}
  spec.homepage      = "https://github.com/treehouse/xcodeproj_merge"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "xcodeproj", "~> 0.28.2"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
