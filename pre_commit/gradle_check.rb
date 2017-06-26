module Overcommit::Hook::PreCommit
  class GradleCheck < Base

    # Constructor.
    def initialize(config, context)
      super(config, context)
      @@required_plugins = ["checkstyle", "pmd", "findbugs"]
    end

    # Runs the hook.
    def run
      if valid_gradle_config?
        result = gradle_check
        return result.nil? ? :pass : [:fail, result]
      else
        return [:fail, "build.gradle must exist and contain plugins #{@@required_plugins}."]
      end
    end

    private

    # Returns true if build.gradle exists and contains all @@required_plugins.
    def valid_gradle_config?
      filename = "./build.gradle"
      valid = false

      if File.exist?(filename)
        contents = File.open(filename, "r").read()
        valid = @@required_plugins.map{ |p| contents.include?("apply plugin: '#{p}'")}.all?
      end

      valid
    end

    # Runs 'gradle check', returning the output in the event of any failures.
    def gradle_check
      stdout, stderr, status = Open3.capture3("./gradlew check")
      if status.success?
        return nil
      else
        return stdout
      end
    end
  end
end
