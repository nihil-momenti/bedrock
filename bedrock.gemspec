# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bedrock/version"

Gem::Specification.new do |s|
  s.name        = "bedrock"
  s.version     = Bedrock::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Wim Looman"]
  s.email       = ["ghostunderscore@gmail.com"]
  s.homepage    = "https://github.com/Nemo157/bedrock"
  s.summary     = %q{The bedrock of the Wave Protocol}
  s.description = %q{TODO: Write a gem description}
  s.licenses    = ["Apache License 2.0"]

  s.rubyforge_project = "bedrock"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '~>1.9.2'

  s.add_development_dependency 'rspec', '~>2.3.0'
  s.add_development_dependency 'cover_me', '~>1.0.0.rc4'
end
