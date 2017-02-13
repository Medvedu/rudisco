# encoding: utf-8
require 'spec_helper'

module Rudisco
  describe Gem do
    it 'includes certain columns' do
      expect(described_class.columns)
        .to include(:id, :name, :description, :source_code_url)
    end

    it 'works as Sequel ORM' do
      expect(described_class.where {total_downloads > 30 }.count)
        .to be > 0
    end

    # ----------------------------------------------------

    describe "#find_phrase" do
      it 'case insensitive searches in :description, :name columns' do
        gems = described_class.find_phrase 'monkey'

        gems.each do |gem|
          expect((gem.name =~ /monkey/i) || (gem.description =~ /monkey/i))
            .to_not be_nil
        end
      end
    end # describe "#find_phrase"

    # ----------------------------------------------------

    describe "#action" do
      it 'raises an exception when action is unknown' do
        sample = described_class.first

        expect{ sample.action :misspelled_action }
          .to raise_exception GemActions::Unknown
      end

      it 'completes an action for single cortege' do
        allow_any_instance_of(Rudisco::GemActions)
          .to receive(:open_in_browser).and_throw(:method_called)

        cortege = described_class.first
        expect{cortege.action :open_in_browser}.to throw_symbol
      end

      it 'completes an action for each cortege in Gems#dataset' do
        allow_any_instance_of(Rudisco::GemActions)
          .to receive(:open_in_browser).and_throw(:method_called)

        dataset = described_class.limit(3)
        dataset.each do |cortege|
          expect{cortege.action :open_in_browser}.to throw_symbol
        end
      end
    end # describe "#action"
  end # describe Gem
end # module Rudisco
