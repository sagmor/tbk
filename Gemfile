source 'https://rubygems.org'

# Specify your gem's dependencies in tbk.gemspec
gemspec

platforms :jruby do
  gem "jruby-openssl"
end

group :docs do
  gem 'yard'
  gem 'redcarpet'
end

group :test do
  gem "codeclimate-test-reporter", require: false
end

