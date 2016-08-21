# encoding: utf-8

require '../lib/rubygems.rb'

RubyGem::Gem.connect(verbose: false)

count = RubyGem::Gem.search('mit', search: [:license]).count
puts "Gems count published with MIT license: #{count}", ''

puts "Gems with 'CRC32' keyword in a name or description."
RubyGem::Gem.search('CRC32', search: [:name, :description]).each do |g|
  puts "Gem name:     #{g.name}"
  puts "Description:  #{g.description}"
  puts "Authors:      #{g.authors}", ''
end
