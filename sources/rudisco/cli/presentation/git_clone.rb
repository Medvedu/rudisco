# encoding: utf-8
# frozen_string_literal: true
module Rudisco
module CLI
  class Presentation::GitClone < Presentation
    # @param [HASH] params
    # @option params  [String, NilClass] :path
    # @option params [TrueClass, FalseClass] :success
    # @option params [Exception, NilClass] :exception

    def initialize(**params)
      @success   = params[:success]
      @path      = params[:path]
      @exception = params[:exception]
    end

    def show # no-doc
      report message: '', complete: '' do
        if success
          git_clone_done
        else
          git_clone_failed
        end
      end # report
    end

    def git_clone_done # no-doc
      header title: 'Gem was cloned!', width: 80, align: 'center',
                                                  bold: true

      aligned "Path to folder #{path}", bold: true, width: 80, align: 'center'
    end

    def git_clone_failed # no-doc
      header title: 'Gem clone failed.', width: 80, align: 'center',
                                                    bold: true

      aligned "Error message: #{exception.message}", bold: true, width: 80,
                                                     align: 'center'
    end

    # @return [String, NilClass]

    attr_reader :path

    # @return [TrueClass, FalseClass]

    attr_reader :success

    # @return [Exception, NilClass]

    attr_reader :exception

  end # class Presentation::GitClone
end # module CLI
end # module Rudisco
