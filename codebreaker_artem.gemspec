# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "codebreaker_artem/version"

Gem::Specification.new do |spec|
  spec.name          = "codebreaker_artem"
  spec.version       = CodebreakerArtem::VERSION
  spec.licenses      = ['MIT']
  spec.authors       = ["b-artem"]
  spec.email         = ["artemb.dev@gmail.com"]

  spec.summary       = %q{Codebreaker game.}
  spec.description   = %q{Codebreaker is a logic game in which a code-breaker
      tries to break a secret code created by a code-maker. The code-maker,
      which will be played by the application, creates a secret code of four
      numbers between 1 and 6.}
  spec.homepage      = "https://github.com/b-artem/codebreaker_artem"
  spec.required_ruby_version = "1.9.3"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'pry', "~> 0.10.0"
end
