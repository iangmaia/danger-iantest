# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iantest/gem_version'

Gem::Specification.new do |spec|
  spec.name          = 'danger-iantest'
  spec.version       = Iantest::VERSION
  spec.authors       = ['Ian Maia']
  spec.description   = 'A short description of danger-iantest.'
  spec.summary       = 'A longer description of danger-iantest.'
  spec.homepage      = 'https://github.com/iangmaia/danger-iantest'
  spec.license       = 'MPL-2.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'danger', '~> 9.3'
  spec.add_dependency 'danger-junit', '~> 1.0'
  spec.add_dependency 'danger-swiftlint', '~> 0.29'
  spec.add_dependency 'danger-xcode_summary', '~> 1.0'

  spec.add_runtime_dependency 'danger-plugin-api', '~> 1.0'

  # General ruby development
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'

  # Testing support
  spec.add_development_dependency 'rspec', '~> 3.4'

  # Linting code and docs
  spec.add_dependency 'rubocop', '~> 1.53'
  spec.add_development_dependency 'yard'

  # Makes testing easy via `bundle exec guard`
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'

  # This gives you the chance to run a REPL inside your tests
  # via:
  #
  #    require 'pry'
  #    binding.pry
  #
  # This will stop test execution and let you inspect the results
  spec.add_development_dependency 'pry'
end
