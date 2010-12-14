require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

namespace :cover_me do
  desc "Generate the cover_me report"
  task :report do
    require 'cover_me'
    CoverMe.complete!
  end
end

namespace :rspec do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
end

desc "Run RSpec and generate the cover_me report"
task :test do
  Rake::Task['rspec:spec'].invoke
  Rake::Task['cover_me:report'].invoke
end

task :default => :test
