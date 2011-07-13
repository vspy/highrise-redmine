require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :gem do
  sh "gem build highrise-redmine.gemspec"
end

task :default => :spec

