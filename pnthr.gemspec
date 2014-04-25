# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pnthr/version'

Gem::Specification.new do |spec|
  spec.name          = "pnthr"
  spec.version       = Pnthr::VERSION
  spec.authors       = ["Clay McIlrath"]
  spec.email         = ["clay.mcilrath@gmail.com"]
  spec.summary       = "Data Encryption with pnthr.net"
  spec.description   = "Encrypt anything and everything in a way that cannot be hacked through pnthr.net"
  spec.homepage      = "https://github.com/thinkclay/pnthr.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
