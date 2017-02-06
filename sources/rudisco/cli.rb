# encoding: utf-8
# frozen_string_literal: true
module Rudisco
  class CLI < Thor
    desc "find PHRASE", "Searches phrase in gem name or description"
    def find(phrase)
    end

    desc "update", "Database update. Can be long-term procedure."
    def update
      puts "Update started!"

      updated = 0
      Gem.deep_scanning do |updated_count|
        updated += updated_count
        print "Updated: #{updated}"
        $stdout.flush
      end

      puts "\nUpdate finished! #{updated} record(s) was updated!"
    end

    desc "statistic", "Shows statistic"
    def statistic
      gem_count = Gem.count

      # FIND OUTDATED RECORDS
      Gem.surface_scanning
      outdated_count = Gem.where { need_update }.count

      ## PRINT REPORT
      puts "Gathering statistic...\n"
      puts "Need update for #{outdated_count} records."
      puts "Records in database: #{gem_count}"
    end
  end # class CLI
end # module Rudisco
