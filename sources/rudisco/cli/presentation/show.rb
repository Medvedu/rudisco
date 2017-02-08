# encoding: utf-8
# frozen_string_literal: true
module Rudisco
module CLI
  class Presentation::Show < Presentation
    def initialize(**params) # no-doc
      @record = params[:record]
    end

    def show # no-doc
      report message: '', complete: '' do
        if record
          show_detailed_gem_description
        else
          gem_not_found
        end
      end # report message
    end

    private

    def gem_not_found # no-doc
      aligned ""
      aligned "Gem not found. Sorry.", bold: true, width: 80,
                                                   align: 'center'
      aligned ""
    end

    def show_detailed_gem_description # no-doc
      table(border: true,  width: 80) do
        row { column 'Description', width: 80, align: 'center' }
        row { column record.description }
      end

      aligned ""

      table(border: false,  width: 80) do
        row do
          column 'Total downloads',   width: 18, align: 'center'
          column 'Version downloads', width: 18, align: 'center'
          column 'Version',           width: 18, align: 'center'
          column 'License',           width: 17, align: 'center'
        end
        row do
          column record.total_downloads
          column record.version_downloads
          column record.version
          column record.license
        end
      end # table

      aligned ""

      table(border: false,  width: 80) do
        row do
          column 'wiki_url',          width: 18, align: 'center'
          column 'documentation_url', width: 18, align: 'center'
          column 'mailing_list_url',  width: 18, align: 'center'
          column 'bug_tracker_url',   width: 17, align: 'center'
        end
        row do
          column url_helper(record.wiki_url)
          column url_helper(record.documentation_url)
          column url_helper(record.mailing_list_url)
          column url_helper(record.bug_tracker_url)
        end
      end # table

      aligned ""

      table(border: false,  width: 80) do
        row do
          column 'Authors', width: 20, align: 'center', padding: 2
          column 'Sha',     width: 57, align: 'center', padding: 10
        end
        row do
          column record.authors
          column record.sha
        end
      end # table
    end

    def url_helper(url) # no-doc
      if url.nil? || url.empty?
        return "no"
      else
        return "yes"
      end
    end

    # @return [Rudisco::Gem]

    attr_reader :record
  end # class Presentation::Show
end # module CLI
end # module Rudisco
