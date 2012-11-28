$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_filter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_filter"
  s.version     = ActiveFilter::VERSION
  s.authors     = ["tnakamura"]
  s.email       = ["griefworker@gmail.com"]
  s.homepage    = "https://github.com/tnakamura/active_filter"
  s.summary     = "Rails engine for allowing users to filter scope dynamically."
  s.description = "ActiveFilter is a Rails engine for allowing users to filter scope dynamically."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.2.9"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
end
