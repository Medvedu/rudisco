# encoding: utf-8

# no-doc
module RubyGem
  # RUBY CORE LIBRARIES
  require 'yaml'
  require 'csv'
  require 'set'
  require 'net/http'
  require 'uri'
  require 'json'

  require File.join(__dir__, 'config')
  require File.join(__dir__, 'notifications')
  require File.join(__dir__, 'helpers')
  require File.join(__dir__, 'initializer')
  require File.join(__dir__, 'gem/manager')

  class GemProxy < ActiveRecord::Base
    class << self
      private

      # search method
      # TO-DO PARAMS VALIDATION
      #
      def search(pattern, params = {})
        search = params.empty? ? Settings.get[:search] : params[:search]
        query = if pattern.is_a? String
                  search.map { |s| "lower(#{s}) LIKE ?" }.join(' OR ')
                else
                  # http://stackoverflow.com/questions/19777720/rails-sql-regular-expression
                  # => Drawing.where("drawing_number REGEXP ?", 'A\d{4}')
                  raise StandartError, 'REGEXP search not implemented!'
                end

        args = Array.new(search.count) { "%#{pattern.downcase}%" }.to_a
        RubyGem::Gem.where(query, *args).all
      end

      #
      #
      #
      def update(params = {})
        Settings.set params
        db_update
      end

      # Initializer
      # TO-DO PARAMS VALIDATION && self.extend RubyGem::Settings && encapsulation
      #
      def connect(params = {})
        Settings.set_defaults
        Settings.set params

        extend RubyGem::Initializer
        extend RubyGem::Manager
      end
    end # class < self
  end # class GemProxy
end # module RubyGem
