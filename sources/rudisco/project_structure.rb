# encoding: utf-8
# frozen_string_literal: true
module Rudisco
  # === Dependencies from core lib

  require 'csv'
  require 'net/http'
  require 'uri'
  require 'json'

  # === Dependencies from rubygems.org

  require 'sqlite3'
  require 'sequel'

  # === Project structure

  ##
  # Ancestor class for Rudisco's exceptions.

  class Error < StandardError; end

  ##
  # Loads *.rb files in requested order.

  def self.load(**params)
    params[:files].each do |f|
      require File.join(__dir__, params[:folder].to_s, f)
    end
  end
  private_class_method :load

  load files: %w(helpers sqlite)

  load folder: 'models/gem',
       files: %w(scanner actions dataset_methods)

  load folder: 'models',
       files: %w(gem)
end # module Rudisco
