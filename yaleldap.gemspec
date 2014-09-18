# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaleldap/version'

Gem::Specification.new do |spec|
  spec.name          = "yaleldap"
  spec.version       = YaleLDAP::VERSION
  spec.authors       = ["caseywatts"]
  spec.email         = ["casey.s.watts@gmail.com"]
  spec.summary       = %q{Easy connection to Yale's LDAP}
  spec.description   = %q{Automatically connects to the LDAP server if you are on campus/VPN. Can be queried by UPI, and it will return a simple ruby hash with the relevant information.}
  spec.homepage      = "http://github.com/YaleSTC/yaleldap"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  # spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  # spec.add_development_dependency "pry"
  # spec.add_development_dependency "pry-remote"
  # spec.add_development_dependency "pry-nav"
  spec.add_runtime_dependency "net-ldap"
end
