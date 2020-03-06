# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "rfc"
  s.version     = "0.0.7"
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors     = ["Oleg Pudeyev"]
  s.email       = "oleg@olegp.name"
  s.homepage    = "https://github.com/p-mongo/rfc"
  s.summary     = "rfc-0.0.7"
  s.description = "RSpec Formatter Collection including a concise insta-failing formatter"

  s.files            = `git ls-files -- lib/*`.split("\n")
  s.files           += %w[README.md LICENSE]
  s.test_files       = []
  s.bindir           = 'bin'
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"

  s.required_ruby_version = '>= 1.9.3'
  s.add_runtime_dependency "rspec-core", "~> 3.0"
end
