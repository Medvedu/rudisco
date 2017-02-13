# encoding: utf-8
# frozen_string_literal: true
module Rudisco

  ##
  # == Table +gems+ structure:
  #
  # CREATE TABLE `gems` (
  # 	`id`	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  #
  # 	`name`        Text,
  # 	`description` Text,
  # 	`authors`     Text,
  # 	`version`     Text,
  # 	`license`     Text,
  # 	`sha`         Text,
  #
  # 	`source_code_url`   Text,
  # 	`project_url`       Text,
  # 	`gem_url`           Text,
  # 	`wiki_url`          Text,
  # 	`documentation_url` Text,
  # 	`mailing_list_url`  Text,
  # 	`bug_tracker_url`   Text,
  #
  # 	`total_downloads`   Integer,
  # 	`version_downloads` Integer,
  #
  # 	`need_update`	Boolean DEFAULT (1)
  # );

  class Gem < Sequel::Model
    extend RubyGemsScanner
    plugin :gem_extended_dataset

    ##
    # Case insensitive phrase search in :description, :name columns.
    #
    # @example
    #   phrase = 'rails'
    #   gems = Rudisco::Gem.find_phrase(phrase)
    #                      .select(:name, :description)
    #
    #   gems.each do |record|
    #     puts record[:name]
    #     puts record[:description]
    #     puts
    #   end
    #
    # @param [String] phrase
    #
    # @return [Gem::Dataset]

    def self.find_phrase(phrase)
      result = from(:gems).find_phrase phrase

      return result
    end

    ##
    # Provides external actions for specified cortege.
    #
    # @example
    #   path_to_load = File.join(__dir__, '..', 'tmp')
    #
    #   sample = Rudisco::Gem.exclude(source_code_url: '').first
    #   sample.action(:open_sources)
    #         .action(:git_clone, path: path_to_load)
    #
    #   sample2 = Rudisco::Gem.limit(2)
    #   sample2.action(:download, path: path_to_load)
    #
    # @param [Symbol] command
    #   Expecting +command+ values:
    #     :update             @see GemActions#update
    #     :open_documentation @see GemActions#open_documentation
    #     :open_bug_tracker   @see GemActions#open_bug_tracker
    #     :open_sources       @see GemActions#open_sources
    #     :open_wiki          @see GemActions#open_wiki
    #     :open_rubygems      @see GemActions#open_rubygmes
    #     :download           @see GemActions#download
    #     :git_clone          @see GemActions#git_clone
    #
    # @param [Hash] params
    #   Additional parameters. Optional.
    #
    # @return [Rudisco::Gem]

    def action(command, params = {})
      GemActions.new(self).complete command, params

      return self
    end
  end # class Gem
end # module Rudisco
