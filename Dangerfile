if danger.env.danger_id == 'pr-check'
    danger.import_dangerfile(path: 'dangerfiles/pr-check/Dangerfile')
end

if @iantest_platform == :ios
    swiftlint.lint_files
end
