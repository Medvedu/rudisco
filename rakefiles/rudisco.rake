# encoding: utf-8
namespace 'Rudisco' do
  desc "(long-term task) Starts multithread Rudisco::Gem table update"
  task 'update' do
    require File.join(__dir__, '..', 'sources', 'rudisco.rb')

    puts "task Rudisco:update launched!"

    Rudisco::Gem.surface_scanning
    totally_updated, outdated =
      0, Rudisco::Gem.where(need_update: true).count

    Rudisco::Gem.deep_scanning do |updated_count|
      totally_updated += updated_count
      print "Updated: #{totally_updated}/#{outdated}\r"
      $stdout.flush
    end

    puts "task Rudisco:update completed the job."
  end # task 'update'
end # namespace 'Rudisco'
