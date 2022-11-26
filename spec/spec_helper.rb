# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::LcovFormatter,
  ]
)
SimpleCov.start do
  # this dir used by CircleCI
  add_filter 'vendor'
  track_files '{app,lib}/**/*.rb'
  enable_coverage(:branch) # Report branch coverage to trigger branch-level undercover warnings
end

require 'webmock/rspec'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.order = 'random'
  config.alias_it_should_behave_like_to :has_behavior
  config.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Monkeypatch RSpec to help us find our place
module RSpec
  module_function

  def root
    # rubocop:disable Naming/MemoizedInstanceVariableName
    @rspec_root ||= Pathname.new(__dir__)
    # rubocop:enable Naming/MemoizedInstanceVariableName
  end
end

# Add the exe directory, to allow testing of gem executables as if the gem is
# already installed.
exec_dir = RSpec.root.join('../exe')
ENV['PATH'] = [exec_dir, ENV.fetch('PATH')].join(File::PATH_SEPARATOR)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[RSpec.root.join('support/**/*.rb')].sort.each { |f| require f }
