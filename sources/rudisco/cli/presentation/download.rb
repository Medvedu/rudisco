# encoding: utf-8
# frozen_string_literal: true
module Rudisco
module CLI
  class Presentation::Download < Presentation

    # @param [HASH] params
    # @option params  [String, NilClass] :path
    # @option params [TrueClass, FalseClass] :success
    # @option params [Exception, NilClass] :exception

    def initialize(**params) # no-doc
      @success   = params[:success]
      @path      = params[:path]
      @exception = params[:exception]
    end

    def show # no-doc
      report message: '', complete: '' do
        if success
          show_download_message
        else
          download_failed
        end
      end # report
    end

    private

    def show_download_message # no-doc
      header title: 'Download success', width: 80, align: 'center', bold: true

      aligned "Gem was downloaded to #{path}", bold: true, width: 80,
                                               align: 'center'
    end

    def download_failed # no-doc
      header title: 'Download failed', width: 80, align: 'center', bold: true

      aligned "Error message: #{exception.message}", bold: true, width: 80,
                                                     align: 'center'
    end

    # @return [String, NilClass]

    attr_reader :path

    # @return [TrueClass, FalseClass]

    attr_reader :success

    # @return [Exception, NilClass]

    attr_reader :exception
  end # class Presentation::Download
end # module CLI
end # module Rudisco
