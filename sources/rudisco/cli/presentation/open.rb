# encoding: utf-8
# frozen_string_literal: true
module Rudisco
module CLI
  class Presentation::Open < Presentation
    def initialize(**params) # no-doc
      @exception = params[:exception]
    end

    def show # no-doc
      aligned "Error! Exception: #{exception.message}",
              bold: true, width: 80, align: 'center'
    end

    private

    # @return [Exception]

    attr_reader :exception
  end # Presentation::Open
end # module CLI
end # module Rudisco
