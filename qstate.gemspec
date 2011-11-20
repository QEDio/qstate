# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "qstate/version"

Gem::Specification.new do |s|
  s.name        = "qstate"
  s.version     = Qstate::VERSION
  s.authors     = ["jak4"]
  s.email       = ["jak4@qed.io"]
  s.homepage    = ""
  s.summary     = %q{QState is a framework for paramters which go in and out of your application (URI, JSON, ..)}
  s.description = %q{Use QState to hide the complexity of generating URLs for object-data you don't know anything about. Qaram talks to those objects and returns the URL if the corresponding functions are provided. It will also deserizalize the data into the corresponding objects'}

  s.rubyforge_project = "qstate"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency('rake')
  s.add_runtime_dependency('activesupport')
  s.add_runtime_dependency('i18n') # require 'active_support/core_ext/string/inflections' has a dependency to it
  s.add_runtime_dependency('yajl-ruby')

  s.add_development_dependency('shoulda')
  s.add_development_dependency('spork')
  s.add_development_dependency('spork-testunit')
  s.add_development_dependency('simplecov')
end
