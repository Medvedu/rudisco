# encoding: utf-8

## PATH TO TEST DATABASE
ENV['RUDISCO_DB'] = File.join(__dir__, 'database', 'rudisco.db')

require_relative '../sources/rudisco'

RSpec.configure do |config|
end
