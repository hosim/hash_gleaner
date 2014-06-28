# -*- coding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name          = "hash_gleaner"
  s.authors       = ["hosim"]
  s.email         = ["github.hosim@gmail.com"]
  s.description   = "HashGleaner allows you to declare hash structure you want to get."
  s.summary       = "HashGleaner allows you to declare hash structure you want to get."
  s.homepage      = "https://github.com/hosim/hash_gleaner"
  s.executables   = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f) }
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  s.version       = "0.1.0"
  s.license       = "MIT"

  s.add_development_dependency 'rspec'
end
