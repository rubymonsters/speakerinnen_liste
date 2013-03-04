# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "bootswatch-rails"
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Maxim Chernyak"]
  s.date = "2013-01-24"
  s.description = "Bootswatches converted to SCSS ready to use in Rails 3 asset pipeline."
  s.email = ["max@bitsonnet.com"]
  s.homepage = "http://github.com/maxim/bootswatch-rails"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Bootswatches in your Rails asset pipeline"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.1"])
    else
      s.add_dependency(%q<railties>, [">= 3.1"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.1"])
  end
end
