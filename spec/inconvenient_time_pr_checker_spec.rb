# frozen_string_literal: true

require_relative 'spec_helper'

module Danger
  describe Danger::InconvenientTimePRChecker do
    it 'should be a plugin' do
      expect(Danger::InconvenientTimePRChecker.new(nil)).to be_a Danger::Plugin
    end

    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.inconvenient_time_pr_checker
      end

      it 'warns on a monday' do
        monday_date = Date.parse('2016-07-11')
        allow(Date).to receive(:today).and_return monday_date

        @my_plugin.warn_on_mondays

        expect(@dangerfile.status_report[:warnings].count).to eq 1
      end

      it 'does nothing on a tuesday' do
        monday_date = Date.parse('2016-07-12')
        allow(Date).to receive(:today).and_return monday_date

        @my_plugin.warn_on_mondays

        expect(@dangerfile.status_report[:warnings]).to be_empty
      end

      it 'warns after 18pm' do
        after18pm = Time.parse('2023-06-30 18:30 UTC')
        allow(Time).to receive(:now).and_return after18pm

        @my_plugin.warn_after_6pm

        expect(@dangerfile.status_report[:warnings].count).to eq 1
      end

      it 'does nothing before 18pm' do
        after18pm = Time.parse('2023-06-30 17:59 UTC')
        allow(Time).to receive(:now).and_return after18pm

        @my_plugin.warn_after_6pm

        expect(@dangerfile.status_report[:warnings]).to be_empty
      end
    end
  end
end
