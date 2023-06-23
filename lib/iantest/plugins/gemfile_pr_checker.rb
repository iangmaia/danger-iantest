# frozen_string_literal: true

module Danger
  # Plugin to check if the Gemfile.lock was updated when changing the Gemfile in a PR.
  class GemfilePRChecker < Plugin
    def check_gemfile_lock_updated
      gemfile_modified = git.modified_files.include?('Gemfile')
      lock_modified = git.modified_files.include?('Gemfile.lock')
      
      if gemfile_modified && !lock_modified
        failure('Gemfile was changed without updating Gemfile.lock. Please run `bundle install` or `bundle update <updated_gem>`.')
      end
    end
  end
end
