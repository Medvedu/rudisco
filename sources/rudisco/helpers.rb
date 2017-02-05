# encoding: utf-8
# frozen_string_literal: true
module Rudisco
  module Helpers
    ##
    # Opens +url+ in a browser.
    #
    # @param [String] url

    def self.open_in_browser(url)
      return if url.to_s.empty?

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
    # Downloads file from +url_to_file+ to +path+.
    #
    # @param [String] url_to_file
    #
    # @param [String, Pathname] path

    def self.download(url_to_file, path)
      system "wget -P #{path} #{url_to_file} > /dev/null 2>&1"
    end

    ##
    # Clones git project from +url_to_git+ to +path+.
    #
    # @param [String] url_to_git
    #
    # @param [String, Pathname] path

    def self.git_clone(url_to_git, path)
      system "git clone #{url_to_git} #{path} > /dev/null 2>&1"
    end
  end # module Helpers
end # module Rudisco
