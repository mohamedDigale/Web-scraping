require 'rubocop/rake_task'

task default: %w[run]

RuboCop::RakeTask.new(:lint) do |task|
  task.patterns = ['lib/**/*.rb', 'test/**/*.rb']
  task.fail_on_error = false
end

task :run do
  ruby 'lib/team-seven-web-scraping.rb'
end

task :test do

end
