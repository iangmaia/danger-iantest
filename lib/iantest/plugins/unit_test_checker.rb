# frozen_string_literal: true

require_relative 'utils/git_utils'

module Danger
  # Plugin to detect classes without Unit Tests in a PR.
  class UnitTestChecker < Plugin
    ANY_CLASS_DETECTOR = /class ([A-Z]\w+)\s*(.*?)\s*{/.freeze
      NON_PRIVATE_CLASS_DETECTOR = /(?:\s|public|internal|protected|final|abstract|static)*class ([A-Z]\w+)\s*(.*?)\s*{/.freeze

    # TODO: create a field that can be set from the Dangerfile
    CLASSES_EXCEPTIONS = [
      /ViewHolder$/,
      /Module$/,
      /ViewController$/
    ].freeze

    # TODO: create a field that can be set from the Dangerfile
    SUBCLASSES_EXCEPTIONS = [
      /(Fragment|Activity)\b/,
      /RecyclerView/
    ].freeze

    # TODO: create a field that can be set from the Dangerfile
    UNIT_TESTS_BYPASS_PR_LABEL = 'unit-tests-exemption'

    def check_missing_tests
      list = find_classes_missing_tests(git_diff: git.diff)

      return if list.empty?

      if danger.github.pr_labels.include?(UNIT_TESTS_BYPASS_PR_LABEL)
        list.each do |c|
          warn("Class `#{c}` is missing tests, but `#{UNIT_TESTS_BYPASS_PR_LABEL}` label was set to ignore this.")
        end
      else
        list.each do |c|
          failure("Please add tests for class `#{c}` (or add `#{UNIT_TESTS_BYPASS_PR_LABEL}` label to ignore this).")
        end
      end
    end

    private

    ClassViolation = Struct.new(:classname, :file)

    # @param [Git::Diff] git_diff the object
    # @return [Array<ClassViolation>] An array of `ClassViolation` objects for each added class that is missing a test
    def find_classes_missing_tests(git_diff:)
      violations = []
      removed_classes = []
      added_test_lines = []

      # Parse the diff of each file, storing test lines for test files, and added/removed classes for non-test files
      git_diff.each do |file_diff|
        path = file_diff.path
        if test_file?(path: path)
          # Store added test lines from test files
          added_test_lines += file_diff.patch.each_line.select do |line|
            GitUtils.change_type(diff_line: line) == :added
          end
        else
          # Detect added and removed classes in non-test files
          file_diff.patch.each_line do |line|
            case GitUtils.change_type(diff_line: line)
            when :added
              matches = line.scan(NON_PRIVATE_CLASS_DETECTOR)
              matches.reject! { |m| class_match_is_exception?(match: m, file: path) }
              violations += matches.map { |m| ClassViolation.new(m[0], path) }
            when :removed
              matches = line.scan(ANY_CLASS_DETECTOR)
              removed_classes += matches.map { |m| m[0] }
            end
          end
        end
      end

      # We only want newly added classes, not if class signature was modified or line was moved
      violations.reject! { |v| removed_classes.include?(v.classname) }
      # For each remaining candidate, only keep the ones _not_ used in a new test
      violations.select { |v| added_test_lines.none? { |line| line =~ /\b#{v.classname}\b/ } }
    end

    # @param [Array<String>] match an array of captured substrings matching our `*_CLASS_DETECTOR` for a given line
    # @param [String] file the path to the file where that class declaration line was matched
    def class_match_is_exception?(match:, file:)
      return true if CLASSES_EXCEPTIONS.any? { |re| match[0] =~ re }

      subclass_regexp = File.extname(file) == '.java' ? /extends ([A-Z]\w+)/ : /\s*:\s*([A-Z]\w+)/
      subclass = match[1].match(subclass_regexp)&.captures&.first
      SUBCLASSES_EXCEPTIONS.any? { |re| subclass =~ re }
    end

    def test_file?(path:)
      GitUtils.android_test_file?(path: path) || GitUtils.ios_test_file?(path: path)
    end
  end
end
