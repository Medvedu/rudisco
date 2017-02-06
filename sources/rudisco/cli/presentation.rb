# encoding: utf-8
# frozen_string_literal: true
module Rudisco
module CLI
  class Presentation # no-doc
    include CommandLineReporter

    def initialize(**params) # no-doc
      raise NotImplementedError, "Abstract class called!"
    end

    def show # no-doc
      raise NotImplementedError, "Abstract method called!"
    end
  end # class Presentation
end # module CLI
end # module Rudisco
