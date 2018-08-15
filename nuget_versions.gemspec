require 'date'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = "nuget_versions"
  spec.version = File.read("VERSION").strip
  spec.platform = Gem::Platform::RUBY
  spec.date = DateTime.now.strftime("%Y-%m-%d")
  spec.authors = [ "Jonathan Gilbert" ]
  spec.email = [ "JonathanG@iQmetrix.com" ]
  spec.license = "LGPL-3.0+"
  spec.homepage = "https://github.com/logiclrd/NuGetVersions"
  spec.summary = "NuGet Version Library"
  spec.description = "Provides facilities for parsing & working with NuGet Versions, which are a superset of Semantic Versions 2.0."
  spec.required_rubygems_version = "~> 2.0"
  spec.files = Dir.glob("lib/**/*") + %w(README.md)
  spec.require_path = "lib"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", "~> 3.0"
end
