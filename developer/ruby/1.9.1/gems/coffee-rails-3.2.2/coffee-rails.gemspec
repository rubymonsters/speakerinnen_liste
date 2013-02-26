$:.push File.expand_path("../lib", __FILE__)
require "coffee/rails/version"

Gem::Specification.new do |s|
  s.name        = "coffee-rails"
  s.version     = Coffee::Rails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Santiago Pastorino"]
  s.email       = ["santiago@wyeworks.com"]
  s.homepage    = ""
  s.summary     = %q{Coffee Script adapter for the Rails asset pipeline.}
  s.description = %q{Coffee Script adapter for the Rails asset pipeline.}

  s.rubyforge_project = "coffee-rails"

  s.add_runtime_dependency 'coffee-script', '>= 2.2.0'
  s.add_runtime_dependency 'railties',      '~> 3.2.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
