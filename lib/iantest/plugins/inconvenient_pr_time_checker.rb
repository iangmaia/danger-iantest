# frozen_string_literal: true

module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  iangmaia/danger-iantest
  # @tags monday, weekends, time
  #
  class InconvenientPRTimeChecker < Plugin
    # An attribute that you can read/write from your Dangerfile
    #
    # @return   [Array<String>]
    attr_accessor :my_attribute

    # A method that you can call from your Dangerfile
    # @return   [void]
    #
    def warn_on_mondays
      warn 'Trying to merge code on a Monday' if Date.today.wday == 1
    end

    # A method that you can call from your Dangerfile
    # @return   [void]
    #
    def warn_after_6pm
      warn 'Trying to merge code after 6pm' if cest_current_time.hour >= 18
    end

    # A method that you can call from your Dangerfile
    # @return   [void]
    #
    def error_friday_6pm
      current_time = cest_current_time

      failure 'Trying to merge code Friday after 6pm 🙄' if current_time.friday? && current_time.hour >= 18
    end

    private

    # Returns the CEST current time
    #
    def cest_current_time
      Time.now.utc.in_time_zone('UTC+2')
    end
  end
end
