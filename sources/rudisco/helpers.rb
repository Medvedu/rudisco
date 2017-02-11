# encoding: utf-8
# frozen_string_literal: true
module Rudisco
  module Helpers
    ##
    # Opens +url+ in a browser.
    #
    # @param [String] url

    def self.open_in_browser(url)
      raise NotAUrl, url unless url =~ URI::regexp(['http','https'])

      if defined?(Launchy) && Launchy.respond_to?(:open)
        Launchy.open url
      else
        if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
          system "start #{url}"
        elsif RbConfig::CONFIG['host_os'] =~ /darwin/
          system "open #{url}"
        elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
          system "xdg-open #{url}"
        end
      end
    end

    ##
    # Downloads file from +url+ to +path+.
    #
    # @param [String] url
    #
    # @param [String, Pathname] path
    #
    # @exception NotAUrl
    #   Raised when +url+ not a string or empty.
    # @exception DirNotExists
    #   Raised when +path+ is not a path to directory.

    def self.download(url, path)
      raise NotAUrl, url unless url =~ URI::regexp(['http','https'])
      raise DirNotExists, path unless Dir.exists? path

      system "wget -P #{path} #{url} > /dev/null 2>&1"
    end

    ##
    # Clones git project from +url+ to +path+.
    #
    # @param [String] url
    #
    # @param [String, Pathname] path
    #
    # @exception NotAUrl
    #   Raised when +url+ not a string or empty.
    # @exception DirShouldNotExists
    #   Raised when git can not clone project, since directory
    #   where it should be saved already exists.

    def self.git_clone(url, path)
      raise NotAUrl, url unless url =~ URI::regexp(['http','https'])
      raise DirShouldNotExists, path if Dir.exists? path

      system "git clone #{url} #{path} > /dev/null 2>&1"
    end

    class NotAUrl < Error # no-doc
      def initialize(url); super "Url '#{url}' is not a string or empty!" end; end

    class DirNotExists < Error # no-doc
      def initialize(dir); super "Directory '#{dir}' not exists!" end; end

    class DirShouldNotExists < Error # no-doc
      def initialize(dir); super "Directory '#{dir}' should not exist!" end; end
  end # module Helpers
end # module Rudisco
