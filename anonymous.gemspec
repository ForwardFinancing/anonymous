lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "anonymous/version"

Gem::Specification.new do |spec|
  spec.name          = "anonymous"
  spec.version       = Anonymous::VERSION
  spec.authors       = ["James Stonehill"]
  spec.email         = ["jamesstonehill@gmail.com"]

  spec.summary       = %q{A gem that makes anonymising data easier.}
  spec.description   = %q{A gem that makes anonymising data easier.}
  spec.homepage      = "https://github.com/jamesstonehill/anonymous"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|gemfiles)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "activerecord"
end
