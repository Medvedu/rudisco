# encoding: utf-8
# frozen_string_literal: true
module Rudisco
module CLI
  class Application < Thor

    desc "find PHRASE", "Searches phrase in gem name or description"
    def find(phrase)
      records = Gem.find_phrase(phrase)
                   .order_by(:total_downloads)

      Presentation::Find.new(records: records).show
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
      Gem.surface_scanning

      gem_count = Gem.count
      outdated_count = Gem.where { need_update }.count

      Presentation::Statistic.new(
        gem_count: gem_count, outdated_count: outdated_count).show
    end
  end # class Application
end # module CLI
end # module Rudisco
