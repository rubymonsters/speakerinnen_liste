# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sass-rails"
  s.version = "3.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["wycats", "chriseppstein"]
  s.date = "2013-01-14"
  s.description = "Sass adapter for the Rails asset pipeline."
  s.email = ["wycats@gmail.com", "chris@eppsteins.net"]
  s.homepage = ""
  s.require_paths = ["lib"]
  s.rubyforge_project = "sass-rails"
  s.rubygems_version = "1.8.25"
  s.summary = "Sass adapter for the Rails asset pipeline."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sass>, [">= 3.1.10"])
      s.add_runtime_dependency(%q<railties>, ["~> 3.2.0"])
      s.add_runtime_dependency(%q<tilt>, ["~> 1.3"])
    else
      s.add_dependency(%q<sass>, [">= 3.1.10"])
      s.add_dependency(%q<railties>, ["~> 3.2.0"])
      s.add_dependency(%q<tilt>, ["~> 1.3"])
    end
  else
    s.add_dependency(%q<sass>, [">= 3.1.10"])
    s.add_dependency(%q<railties>, ["~> 3.2.0"])
    s.add_dependency(%q<tilt>, ["~> 1.3"])
  end
end
