# frozen_string_literal: true

require 'quality/rake/task'

Quality::Rake::Task.new do |task|
  task.exclude_files = ['Gemfile.lock']
  task.skip_tools = %w[reek cane]
  task.output_dir = 'metrics'
  task.punchlist_regexp = 'XXX|TODO|FIXME|OPTIMIZE|HACK|REVIEW|LATER|FIXIT|xit '
end
