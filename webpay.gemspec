# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "webpay/version"

Gem::Specification.new do |s|
  s.name        = "webpay"
  s.version     = Webpay::VERSION
  s.author      = "Sebastian Gamboa"
  s.email       = "me@sagmor.com"
  s.homepage    = "https://github.com/sagmor/webpay"
  s.summary     = %q{Transbank's Webpay payment service unofficial ruby implementation}
  s.description = %q{Transbank's Webpay payment service unofficial ruby implementation}

  s.rubyforge_project = "webpay"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", ">= 2.7.0"
end
