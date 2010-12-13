require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc "Run Rspec"
RSpec::Core::RakeTask.new(:rspec)

desc "Run Rcov on the RSpec specs"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
end
