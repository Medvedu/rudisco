# encoding: utf-8
# frozen_string_literal: true
module Rudisco
module CLI
  class Application < Thor
    desc "find PHRASE", "Searches phrase in gem name or description"
    method_option :limit,
                  :aliases  => "-l",
                  :type     => :numeric,
                  :default  => 75,
                  :desc     => "Limits search result. By default it shows 75 most popular gems",
                  :banner   => "Search result limit (75 gems by default)"

    def find(phrase)
      records = Gem.find_phrase(phrase)
                   .order_by(Sequel.desc(:total_downloads))
                   .limit options[:limit]

      Presentation::Find.new(records: records).show
    end

    # ----------------------------------------------------

    desc "show GEM_NAME", "Shows detailed information about single gem"
    def show(gem_name)
      record = Gem.where(name: gem_name)
                  .first

      Presentation::Show.new(record: record).show
    end

    # ----------------------------------------------------

    desc "download GEM_NAME", "Downloads a gem"
    method_option :path,
                  :aliases  => "-p",
                  :type     => :string,
                  :default  => nil,
                  :desc     => "Path where gem gonna be saved (default: ENV['HOME'])"

    def download(gem_name)
      record = Gem.where(name: gem_name).first

      if record
        path = File.expand_path(options[:path] || ENV['HOME'])

        record.action :download, path: path
        Presentation::Download.new(success: true, path: path).show
      else
        raise GemNotFound, gem_name
      end

    rescue Rudisco::Error => exception
      Presentation::Download.new(success: false, exception: exception).show
    end

    # ----------------------------------------------------

    desc "clone GEM_NAME", "Clones gem sources from git"
    method_option :path,
              :aliases  => "-p",
              :type     => :string,
              :default  => nil,
              :desc     => "Path where gem gonna be saved (default: ENV['HOME'])"

    def clone(gem_name)
      record = Gem.where(name: gem_name).first

      if record
        path = File.expand_path(options[:path] || ENV['HOME'])

        record.action :git_clone, path: path
        Presentation::GitClone.new(success: true, path: path).show
      else
        raise GemNotFound, gem_name
      end

    rescue Rudisco::Helpers::NotAUrl
      exception = GemWithoutGitSources.new(gem_name)
      Presentation::GitClone.new(success: false, exception: exception).show

    rescue Rudisco::Error => exception
      Presentation::GitClone.new(success: false, exception: exception).show
    end

    # ----------------------------------------------------

    # desc "update", "Database update. Can be long-term procedure."
    # def update
    #   puts "Update started!"
    #
    #   updated = 0
    #   Gem.deep_scanning do |updated_count|
    #     updated += updated_count
    #     print "Updated: #{updated}"
    #     $stdout.flush
    #   end
    #
    #   puts "\nUpdate finished! #{updated} record(s) was updated!"
    # end
    #
    # desc "statistic", "Shows statistic"
    # def statistic
    #   Gem.surface_scanning
    #
    #   gem_count = Gem.count
    #   outdated_count = Gem.where { need_update }.count
    #
    #   Presentation::Statistic.new(
    #     gem_count: gem_count, outdated_count: outdated_count).show
    # end

    class GemNotFound < Error # no-doc
      def initialize(name); super "Gem '#{name}' not found!" end; end

    class GemWithoutGitSources < Error # no-doc
      def initialize(name); super "Gem '#{name}' without git sources!" end; end
  end # class Application
end # module CLI
end # module Rudisco
