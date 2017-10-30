lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/queue/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-queue'
  spec.version       = Fastlane::Queue::VERSION
  spec.author        = 'Josh Holtz'
  spec.email         = 'me@joshholtz.com'

  spec.summary       = 'Queue up fastlane jobs'
  spec.homepage      = "https://github.com/joshdholtz/fastlane-plugin-queue"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'resque', '~> 1.27'
  spec.add_dependency 'vegas', '~> 0.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'fastlane', '>= 2.53.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
