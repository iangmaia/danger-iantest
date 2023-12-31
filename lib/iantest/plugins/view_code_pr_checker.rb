# frozen_string_literal: true

module Danger
  # Plugin to detect View files in a PR but without having accompanying screenshots.
  class ViewCodePRChecker < Plugin
    VIEW_EXTENSIONS_IOS = /(View|Button)\.swift$|\.xib$|\.storyboard$/.freeze
    VIEW_EXTENSIONS_ANDROID = /(?i)(View|Button)\.(java|kt|xml)$/.freeze

    def view_changes_need_screenshots
      view_files_modified = git.modified_files.any? do |file|
        VIEW_EXTENSIONS_IOS =~ file || VIEW_EXTENSIONS_ANDROID =~ file
      end
      pr_has_screenshots = github.pr_body =~ %r{https?://\S*\.(gif|jpg|jpeg|png|svg){1}}
      pr_has_screenshots ||= github.pr_body =~ /!\[(.*?)\]\((.*?)\)/

      warning = 'View files have been modified, but no screenshot is included in the pull request.'\
                ' Consider adding one for clarity.'
      warn(warning) if view_files_modified && !pr_has_screenshots
    end
  end
end
