# encoding: utf-8
# frozen_string_literal: true
module Rudisco
  class CLI < Thor
    desc "find PHRASE", "Searches phrase in gem name or description"
    def find(phrase)
    end

    desc "update", "Updates database"
    def update
      totally_updated, outdated =
        0, Rudisco::Gem.where(need_update: true).count

      Rudisco::Gem.deep_scanning do |updated_count|
        totally_updated += updated_count
        print "Updated: #{totally_updated}/#{outdated}\r"
        $stdout.flush
      end
    end

    desc "statistic", "Shows statistic"
    def statistic
    end
  end # class CLI
end # module Rudisco
