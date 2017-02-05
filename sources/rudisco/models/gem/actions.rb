# encoding: utf-8
# frozen_string_literal: true
module Rudisco
  class GemActions
    # @param [Rudisco::Gem] gem
    #
    # @return [Rudisco::GemActions]

    def initialize(gem)
      @gem = gem
    end

    ##
    # Creates an instance of GemActions class.
    #
    # @param [Symbol] action
    #   Described in Gem#action
    #
    # @param [Hash] params
    #   Additional parameters. Optional.
    #
    # @exception Rudisco::GemActions::ActionUnknown
    #   Raised when action is unknown.

    def complete(action, params = {})
      if respond_to? action
        send action, params
      else
        raise Unknown, action
      end
    end

    ##
    # Opens in browser documentation page

    def open_documentation(params = {})
      Helpers.open_in_browser gem.documentation_url
    end

    ##
    # Opens in browser bug tracker page

    def open_bug_tracker(params = {})
      Helpers.open_in_browser gem.bug_tracker_url
    end

    ##
    # Opens in browser code sources page.

    def open_sources(params = {})
      Helpers.open_in_browser gem.source_code_url
    end

    ##
    # Opens in browser wiki page.

    def open_wiki(params = {})
      Helpers.open_in_browser gem.wiki_url
    end

    ##
    # Downloads gem.
    #
    # @param [Hash] params
    # @option params [String] :path (ENV['HOME'])

    def download(params = {})
      path = params[:path] || ENV['HOME']

      Helpers::download gem.gem_url, path
    end

    ##
    # Clones gem from git.
    #
    # @param [Hash] params
    # @option params [String] :path (ENV['HOME'])

    def git_clone(params = {})
      path = params[:path] || ENV['HOME']
      path = File.join(path, gem.name)

      Helpers::git_clone gem.source_code_url, path
    end

    private

    # @return [Rudisco::Gem]

    attr_reader :gem

    class Unknown < Error # no-doc
      def initialize(action); super "Action '#{action}' is unknown!" end; end
  end # class GemActions
end # module Rudisco
