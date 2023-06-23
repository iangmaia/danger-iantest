danger.import_plugin(File.join(__dir__, 'lib/iantest/plugins/manifest_pr_checker.rb'))
danger.import_plugin(File.join(__dir__, 'lib/iantest/plugins/inconvenient_time_pr_checker.rb'))
danger.import_plugin(File.join(__dir__, 'lib/iantest/plugins/unit_test_pr_checker.rb'))
danger.import_plugin(File.join(__dir__, 'lib/iantest/plugins/view_code_pr_checker.rb'))

if danger.env.danger_id == 'pr-check'
    danger.import_dangerfile(path: 'dangerfiles/pr-check/Dangerfile')
end

if @iantest_platform == :ios
    swiftlint.lint_files
end
