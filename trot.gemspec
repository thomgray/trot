
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "trot/version"

Gem::Specification.new do |spec|
  spec.name          = "trot"
  spec.version       = Trot::VERSION
  spec.authors       = ["Thom Gray"]
  spec.email         = ["thomdikdave@hotmail.com"]

  spec.summary       = %q{A simple command line tool for building projects in C.}
  spec.homepage      = "https://github.com/thomgray/trot"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   << 'trot'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
