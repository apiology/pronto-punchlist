# frozen_string_literal: true

desc 'Load up pronto-punchlist in pry'
task :console do |_t|
  exec 'pry -I lib -r pronto-punchlist'
end
