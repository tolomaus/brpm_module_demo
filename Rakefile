require 'rubygems'
require 'bundler/setup'
require 'rspec/core/rake_task'
require "bundler/gem_tasks"

# Immediately sync all stdout so that tools like buildbot can
# immediately load in the output.
$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file.
Dir.chdir(File.expand_path("../", __FILE__))

# This installs the tasks that help with gem creation and
# publishing.       ra
Bundler::GemHelper.install_tasks

# Install the `spec` task so that we can run tests.
RSpec::Core::RakeTask.new do |task|
  task.pattern = "tests/**/*_spec.rb"
end

# Default task is to run the unit tests
task :default => "spec"

# geminabox private gem server
# Don't push the gem to rubygems
ENV["gem_push"] = "false" # Utilizes feature in bundler 1.3.0

# Let bundler's release task do its job, minus the push to Rubygems,
# and after it completes, use "gem inabox" to publish the gem to our
# internal gem server.
Rake::Task["release"].enhance do
  spec = Gem::Specification::load(Dir.glob("*.gemspec").first)
  sh "gem inabox pkg/#{spec.name}-#{spec.version}.gem"
end
