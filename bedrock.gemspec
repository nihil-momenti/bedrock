# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bedrock/version"

Gem::Specification.new do |s|
  s.name        = "bedrock"
  s.version     = Bedrock::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Wim Looman"]
  s.email       = ["ghostunderscore@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{The bedrock of the Wave Protocol}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "bedrock"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
