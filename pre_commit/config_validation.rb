require 'open3'

module Overcommit::Hook::PreCommit
  # Runs config validation
  class ConfigValidation < Base
    def run
      if File.exist?("./config-validator/index.js")
        test_result = run_config_validation
        return test_result.nil? ? :pass : [:fail, test_result]
      else
        return [:fail, "Config validation file does not exist"]
      end
    end

    private

    def run_config_validation
      stdout, stderr, status = Open3.capture3("node --use_strict ./config-validator/index.js")
      if status.success?
        return nil
      else
        return stdout
      end
    end
  end
end
