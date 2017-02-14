# encoding: utf-8
# frozen_string_literal: true
require_relative '../lib/rudisco'

gems = Rudisco::Gem # Sequel::Model

top = gems.where{ total_downloads > 50000000 }
          .select(:name, :description, :source_code_url)

top.each do |record|
  puts record[:name]
  puts record[:description]
  puts record[:source_code_url] if record[:source_code_url]
  puts
end
