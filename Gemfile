source 'https://rubygems.org'

# Specify your gem's dependencies in tbk.gemspec
gemspec
gem 'coveralls', :require => false

platforms :jruby do
  gem "jruby-openssl"
end

group :docs do
  gem 'yard'
  gem 'redcarpet'
end

require "codeclimate-test-reporter"
