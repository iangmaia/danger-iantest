danger.import_plugin('lib/iantest/plugins/inconvenient_time_pr_checker.rb')
danger.import_plugin('lib/iantest/plugins/unit_test_checker.rb')
danger.import_plugin('lib/iantest/plugins/view_code_pr_checker.rb')

warn('Please provide a summary of the changes in the Pull Request description') if github.pr_body.length < 5
warn('Please keep the Pull Request small, breaking it down into multiple ones if necessary') if git.lines_of_code > 500

inconvenient_time_pr_checker.warn_after_6pm

unit_test_checker.check_missing_tests

view_code_pr_checker.view_changes_need_screenshots
