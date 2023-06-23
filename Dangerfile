danger.import_plugin(File.join(__dir__, 'lib/iantest/plugins/inconvenient_time_pr_checker.rb'))
danger.import_plugin(File.join(__dir__, 'lib/iantest/plugins/manifest_pr_checker.rb'))
danger.import_plugin(File.join(__dir__, 'lib/iantest/plugins/unit_test_pr_checker.rb'))
danger.import_plugin(File.join(__dir__, 'lib/iantest/plugins/view_code_pr_checker.rb'))

case danger.env.danger_id
when 'pr-check'
  danger.import_dangerfile(path: File.join(__dir__, 'dangerfiles/pr-check/Dangerfile'))

  # linting and other validation can also be grouped in another type of check, with a different danger_id
  case @iantest_platform
  when :ios
    swiftlint.lint_files
  when :android
    warn 'TODO: common checks for Android'
  end
  
when 'post-build'
  danger.import_dangerfile(path: File.join(__dir__, 'dangerfiles/post-build/Dangerfile'))
end
