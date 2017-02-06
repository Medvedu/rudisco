# encoding: utf-8
# frozen_string_literal: true
module Rudisco
module CLI
  class Presentation::Download < Presentation
    def initialize(**params) # no-doc
      @success = params[:success]
      @path = params[:path]
      @exception = params[:exception]
    end

    def show # no-doc
    end

    private

    # @return [TrueClass, FalseClass]

    attr_reader :success

    # @return [String, NilClass]

    attr_reader :path

    # @return [Exception, NilClass]

    attr_reader :exception
  end # class Presentation::Download
end # module CLI
end # module Rudisco
