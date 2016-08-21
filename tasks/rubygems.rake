#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'rake'

# TODO: change for gem path, when it will be published to rubygems…
require "#{__dir__}/../lib/rubygems.rb"

desc 'Update rubygems database. Required external connection to '       \
     'rubygems.org. Highly recommended for launch as cron since it is ' \
     'a long-term task.'

task :update_rubygems_db do
  RubyGem::Gem.connect(verbose: true, skip_headers_download: false)
  RubyGem::Gem.update(manager: { ThreadsCount: 20 })
end
