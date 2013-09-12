# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sis_circular_array/version'
require 'require_all'

Gem::Specification.new do |spec|
  spec.name          = "sis_circular_array"
  spec.version       = SisCircularArray::VERSION
  spec.authors       = ["Tyler Thrailkill"]
  spec.email         = ["tylerbthrailkill@gmail.com"]
  spec.description   = %q{Simple Inventory System from Discrete Event Simulation}
  spec.summary       = %q{Evaluates Exercises 1.3.2 and 1.3.8 from the Computer Simulation book, Discrete Event Simulation - A First Course by Lemmis Park}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency 'trollop'
  spec.add_dependency 'require_all'
  
end
