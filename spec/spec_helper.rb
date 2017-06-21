require "bundler/setup"
require 'codebreaker_artem/game'
require 'codebreaker_artem/cli'
require 'codebreaker_artem/starter'
require 'test_data/test_data'

RSpec.configure do |config|
  original_stdout = $stdout
  config.before(:all) do
    $stdout = File.open(File::NULL, "w")
  end
  config.after(:all) do
    $stdout = original_stdout
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
