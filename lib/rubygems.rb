# encoding: utf-8

# REQUIRED GEMS
require 'active_record'
require 'pg'

# PROJECT DEPENDENCY
require File.join(__dir__, 'rubygems', 'core')

module RubyGem
  class Gem < RubyGem::GemProxy
    class << self
      #
      # Search by REGEXP or STRING, default search column is 'name'.
      # returns a record with pattern as substring for selected column(s),
      # independent from upper/lower case.
      #
      def search(pattern, params = {})
        super
      end

      #
      # Load information about gems
      #
      def update(params = {})
        super
      end

      #
      # Initializer
      #
      def connect(params = {})
        super
      end

      #
      # Only for gems with known git
      #
      # def git_clone_to(path)
      #   super
      # end

      #
      # Download a gem
      #
      # def download_to(path)
      #   super
      # end
    end # class << self
  end # class Gem
end # module RubyGem
