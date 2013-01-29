# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tbk/version'

Gem::Specification.new do |gem|
  gem.name          = "tbk"
  gem.version       = TBK::VERSION::GEM
  gem.authors       = ["Seba Gamboa"]
  gem.email         = ["me@sagmor.com"]
  gem.description   = %q{Ruby implementation of Transbank's Webpay protocol}
  gem.summary       = "Pure Ruby implementation of Transbank's Webpay KCC #{TBK::VERSION::KCC}"
  gem.homepage      = TBK::VERSION::WEBSITE

  gem.files         = `git ls-files`.split($/).grep(%r{^(?!example)/})
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "tzinfo"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
