# encoding: utf-8
# frozen_string_literal: true
module Rudisco
module CLI
  class Presentation::Update < Presentation
    def initialize(**params) # no-doc
      @outdated = params[:outdated]

      self.formatter = 'progress'
    end

    def show # no-doc
      header title: 'Update starting...', width: 80, align: 'center',
             bold: true, timestamp: true

      if outdated.zero?
        aligned "Nothing to do!", width: 80, align: 'center'
      else
        aligned "#{outdated} records going to be added/updated.", width: 80,
                 align: 'center'
      end
    end

    def update(**params) # no-doc
      print "Updating...#{params[:updated]}/#{outdated}\r"
      $stdout.flush
    end

    def finished  # no-doc
      aligned "Update finished! All records updated!", width: 80,
                                                       align: 'center'
    end

    private

    # @return [Integer]

    attr_reader :outdated
  end # class Presentation::Update
end # module CLI
end # module Rudisco
