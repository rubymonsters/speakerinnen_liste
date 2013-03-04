# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "bootstrap-sass"
  s.version = "2.0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Thomas McDonald"]
  s.date = "2012-06-26"
  s.email = "tom@conceptcoding.co.uk"
  s.homepage = "http://github.com/thomas-mcdonald/bootstrap-sass"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Twitter's Bootstrap, converted to Sass and ready to drop into Rails or Compass"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<compass>, [">= 0"])
      s.add_development_dependency(%q<sass-rails>, ["~> 3.1"])
    else
      s.add_dependency(%q<compass>, [">= 0"])
      s.add_dependency(%q<sass-rails>, ["~> 3.1"])
    end
  else
    s.add_dependency(%q<compass>, [">= 0"])
    s.add_dependency(%q<sass-rails>, ["~> 3.1"])
  end
end
