# encoding: utf-8
require 'bundler'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new
task default: :spec

path_to_rakes = File.join __dir__, 'rakefiles'
Dir.glob(File.join(path_to_rakes, '**/*')).each do |file|
  import file if File.extname(file) == '.rake'
end
