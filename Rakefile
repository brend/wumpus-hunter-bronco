require 'rspec/core/rake_task'

task :default => [:spec]

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '-c -fd'
end

