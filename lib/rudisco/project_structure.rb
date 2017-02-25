# encoding: utf-8
# frozen_string_literal: true
module Rudisco
  # === Dependencies from core lib

  require 'csv'
  require 'net/http'
  require 'uri'
  require 'json'
  require 'tempfile'
  require 'openssl'

  # === Dependencies from rubygems.org

  require 'sqlite3'
  require 'sequel'
  require 'thor'
  require 'command_line_reporter'

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

  # === Core

  load files: %w(helpers sqlite)

  load folder: 'models/gem',
       files: %w(rubygems_scanner actions dataset_methods)

  load folder: 'models',
       files: %w(gem)

  # === Command-Line-Interface

  load folder: 'cli',
       files: %w(presentation)

  load folder: 'cli/presentation',
       files: %w(find show update download git_clone open)

  load files: %w(cli/cli) # cli/routes
end # module Rudisco
