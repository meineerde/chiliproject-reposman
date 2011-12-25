# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "reposman/version"

Gem::Specification.new do |s|
  s.name        = "reposman"
  s.version     = Reposman::VERSION
  s.authors     = ["The ChiliProject Team"]
  s.email       = ["info@chiliproject.org"]
  s.homepage    = ""
  s.summary     = %q{Creates and manages repositories for ChiliProject}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "reposman"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # ActiveResource to communicate with ChiliProject
  s.add_runtime_dependency "activeresource", "2.3.14"
end
