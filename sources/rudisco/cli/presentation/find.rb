# encoding: utf-8
# frozen_string_literal: true
module Rudisco
module CLI
  class Presentation::Find < Presentation
    def initialize(**params)
      @records = params[:records]
    end

    def show # no-doc
      if records.count.zero?
        nothing_was_found
      else
        show_results
      end
    end

    private

    # @return Array<Rudisco::Gem>

    attr_reader :records

    def nothing_was_found # no-doc
      aligned ""
      header title: 'Rudisco search results',
             width: 80, align: 'center',
             bold: true, timestamp: true

      aligned "Nothing was found. Sorry.", bold: true, width: 80,
                                           align: 'center'
    end

    def show_results # no-doc
      report message: '', complete: '' do

        header title: 'Rudisco search results',
               width: 80, align: 'center',
               bold: true, timestamp: true

        table(border: true) do
          row do
            column '№',           width: 3,  align: 'center'
            column 'Name',        width: 17, align: 'center'
            column 'Description', width: 40, align: 'center', padding: 1
            column 'Downloads (all)', width: 6, align: 'center'
            column 'Downloads (ver)', width: 6, align: 'center'
          end
          records.each_with_index do |rec, index|
            row do
              column index
              column rec.name
              column rec.description
              column rec.total_downloads
              column rec.version_downloads
            end
          end
        end # table
      end
    end
  end # class Presentation::Find
end # module CLI
end # module Rudisco
