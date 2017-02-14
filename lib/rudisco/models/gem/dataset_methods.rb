# encoding: utf-8
# frozen_string_literal: true
module Sequel::Plugins::GemExtendedDataset
  module DatasetMethods
    # @see Rudisco::Gem#action
    #
    # @return [Gem::Dataset]

    def action(command, params = {})
      each { |cortege| cortege.action command, params }

      return self
    end

    # @see Rudisco::Gem#find_phrase
    #
    # @return [Gem::Dataset]

    def find_phrase(word)
      search_filter =
        Sequel.ilike(:name, "%#{word}%") || Sequel.ilike(:description, "%#{word}%")

      dataset = where search_filter

      return dataset
    end
  end # module DatasetMethods
end # Sequel::Plugins::GemExtendedDataset
