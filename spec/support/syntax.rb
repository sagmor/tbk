RSpec.configure do |config|
  config.expect_with :rspec do |expect|
    expect.syntax = :expect
  end

  # see https://github.com/rspec/rspec-expectations/blob/master/spec/spec_helper.rb
  shared_context "with #should enabled", :uses_should do
    orig_syntax = nil

    before(:all) do
      orig_syntax = RSpec::Matchers.configuration.syntax
      RSpec::Matchers.configuration.syntax = [:expect, :should]
    end

    after(:all) do
      RSpec::Matchers.configuration.syntax = orig_syntax
    end
  end
end
