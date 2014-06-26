# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-repp/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-repp"
  s.version     = OmniAuth::Repp::VERSION
  s.authors     = ["Alex Sears"]
  s.email       = ["alexwsears@gmail.com"]
  s.homepage    = "https://github.com:Kandidly/omniauth-repp"
  s.summary     = %q{OmniAuth strategy for Repp}
  s.description = %q{OmniAuth strategy for Repp}
  s.license     = "MIT"

  s.rubyforge_project = "omniauth-repp"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'omniauth-oauth2', '~> 1.0'
end
