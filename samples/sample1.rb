# encoding: utf-8

require '../lib/rubygems.rb'

RubyGem::Gem.connect

hot_with_git_sourse = RubyGem::Gem.where('downloads_count_all < 2000000 ')
                                  .where('downloads_count_last > 500000')
                                  .where('sourse_code_uri is not NULL')
                                  .limit(100)

hot_with_git_sourse.each do |g|
  puts "Gem name:     #{g.name}"
  puts "Description:  #{g.description}"
  puts "Sourse link:  #{g.sourse_code_uri}"
  puts "Authors:      #{g.authors}", ''
end
