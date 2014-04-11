require 'bundler/setup'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'tbk'

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }
