require 'open3'

module Overcommit::Hook::PreCommit
  class NodeNpmRunLint < Base
    def run
      test_result = run_lint
      return test_result.nil? ? :pass : [:fail, test_result]
    end

    private

    def run_lint
      stdout, stderr, status = Open3.capture3("npm run lint")
      if status.success?
        return nil
      else
        return stdout
      end
    end
  end
end
