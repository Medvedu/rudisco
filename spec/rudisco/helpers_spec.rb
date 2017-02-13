# encoding: utf-8
require 'spec_helper'

module Rudisco
  describe Helpers do
    context "#open_in_browser" do
      it 'raises an exception when +url+ is not a string' do
        expect { described_class.open_in_browser(:url) }
          .to raise_exception described_class::NotAUrl
      end

      it 'raises an exception when +url+ is a empty string' do
        expect { described_class.open_in_browser('') }
          .to raise_exception described_class::NotAUrl
      end
    end # context "#open_in_browser"


    context "#download" do
      it 'raises an exception when +url+ is a empty string' do
        expect { described_class.download('', nil) }
          .to raise_exception described_class::NotAUrl
      end
    end # context "#download"

    context "#git_clone" do
      it 'raises an exception when +url+ is a empty string' do
        expect { described_class.git_clone('', nil) }
          .to raise_exception described_class::NotAUrl
      end
    end # context "#git_clone"
  end # describe "Helpers"
end # module Rudisco
