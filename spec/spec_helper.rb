require 'bundler/setup'
require 'tbk'
require 'coveralls'
Coveralls.wear!

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }
