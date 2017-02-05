# encoding: utf-8
# frozen_string_literal: true
require_relative '../sources/rudisco'

phrase = 'rails'
gems = Rudisco::Gem.find_phrase(phrase)
                   .select(:name, :description)

gems.each do |record|
  puts record[:name]
  puts record[:description]
  puts
end
