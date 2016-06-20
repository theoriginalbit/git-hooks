require 'open3'

module Overcommit::Hook::PreCommit
  # Runs mocha unit test
  class MochaUnitTest < Base
    def run
      if File.exist?("./test/unit/")
        test_result = run_unit_test
        return test_result.nil? ? :pass : [:fail, test_result.join("\n")]
      else
        return [:fail, "Mocha unit test directory doesn't exist"]
      end
    end

    private

    def run_unit_test
      stdout, stderr, status = Open3.capture3("node_modules/.bin/mocha --use_strict ./test/unit/")
      if status.success?
        return nil
      else
        return ["Error: #{stdout}"]
      end
    end
  end
end
