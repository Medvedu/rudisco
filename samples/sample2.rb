# encoding: utf-8

require '../lib/rubygems.rb'

RubyGem::Gem.connect

popular = RubyGem::Gem.where('downloads_count_all > 4000000 ')
                      .order('downloads_count_last DESC')
                      .limit(100)

popular.each do |g|
  puts "Gem name:     #{g.name}"
  puts "Description:  #{g.description}"
  puts "Authors:      #{g.authors}", ''
end
