require 'yaml'

module Overcommit::Hook::PreCommit
  # Checks Overcommit config against template
  class OvercommitConfig < Base
    def run
      root = execute(%w[git rev-parse --show-toplevel]).stdout.strip
      template = YAML.load_file("#{File.dirname(__FILE__)}/../.overcommit.yml")
      actual = YAML.load_file("#{root}/.overcommit.yml")

      conflicts = get_conflicts("", template, actual)
      return conflicts.empty? ? :pass : [:fail, conflicts.join("\n")]
    end

    private

    def get_conflicts(path, template, actual)
      if template.is_a? Hash
        if actual.is_a? Hash
          return template.map{ |k, v| get_conflicts("#{path}.#{k}", v, actual[k]) }.flatten.compact
        else
          return ["At #{path}: expected something like #{template.inspect}, but was #{actual.inspect}"]
        end
      elsif template == actual
        return nil
      else
        return ["At #{path}: expected #{template.inspect}, but was #{actual.inspect}"]
      end
    end
  end
end
