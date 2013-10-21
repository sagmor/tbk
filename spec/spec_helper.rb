require 'bundler/setup'
require 'coveralls'
Coveralls.wear!

require 'tbk'

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }
