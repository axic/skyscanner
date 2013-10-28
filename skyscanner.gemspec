# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name        = "skyscanner"
  gem.version     = "0.1"
  gem.authors     = ["Alex Beregszaszi"]
  gem.email       = ["alex@rtfs.hu"]
  gem.description = "A Ruby wrapper for the Skyscanner API. See http://www.skyscanneraffiliate.net/portal/en-GB/US/api/overview for the official documentation."
  gem.summary     = "A Ruby wrapper for the Skyscanner API."
  gem.homepage    = "http://github.com/axic/skyscanner"
  gem.license     = "MIT"

  gem.add_dependency "faraday"
  gem.add_dependency "multi_json"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
end
