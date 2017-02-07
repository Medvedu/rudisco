# encoding: utf-8
# frozen_string_literal: true
module Rudisco
module CLI
  class Presentation::Find < Presentation
    def initialize(**params) # no-doc
      @records = params[:records]
    end

    def show # no-doc
      report message: '', complete: '' do
        if records.count.zero?
          nothing_was_found
        else
          show_results
        end
      end # report
    end

    private

    # @return Array<Rudisco::Gem>

    attr_reader :records

    def nothing_was_found # no-doc
      header title: 'Rudisco search results',
             width: 80, align: 'center',
             bold: true, timestamp: true

      aligned "Nothing was found. Sorry.", bold: true, width: 80,
                                           align: 'center'
    end

    def show_results # no-doc
      header title: 'Rudisco search results',
             width: 80, align: 'center',
             bold: true, timestamp: true

      table(border: true) do
        row do
          column '№',            width: 3,  align: 'center'
          column 'Name',         width: 17, align: 'center'
          column 'Git',          width: 3,  align: 'center'
          column 'Description',  width: 46, align: 'center'
          column 'DW (total)',   width: 10, align: 'center'
        end
        records.each_with_index do |rec, index|
          row do
            column index
            column rec.name
            column source_code_helper(rec.source_code_url)
            column clear_desc_helper(rec.description)
            column rec.total_downloads
          end
        end
      end # table
    end

    ##
    # Returns copy of +description+ string, but without
    # special symbols.
    #
    # @param [String] description
    #   Original string.
    #
    # @return [String]

    def clear_desc_helper(description)
      tmp = description.dup
      return "N/A" if tmp.nil? || tmp.empty?

      tmp = tmp.delete "#{1.chr}-#{31.chr}".split.join ' '

      return tmp
    end

    def source_code_helper(source_code_url) # no-doc
      if source_code_url.nil? || source_code_url.empty?
        return "-"
      else
        return "+"
      end
    end
  end # class Presentation::Find
end # module CLI
end # module Rudisco
