require 'find'

module Overcommit::Hook::PreCommit
  # Checks Overcommit config against template
  class UsesHlint < Base
    def run
      root = execute(%w[git rev-parse --show-toplevel]).stdout.strip
      errors = Find.find(root).map(&method(:badness)).compact
      return errors.empty? ? :pass : [:fail, errors.join("\n")]
    end

    private

    def badness(path)
      bname = File.basename(path)
      if bname.end_with?(".cabal")
        block = <<-EOF
  test-suite hlint
      type:                exitcode-stdio-1.0
      main-is:             HLint.hs
  EOF
        pat = /test-suite hlint\n +type: +exitcode-stdio-1\.0\n +main-is: +HLint\.hs/
        return "#{path} must include HLint block:\n#{block}" unless File.open(path) { |f| f.read.match(pat) }
      elsif bname == "HLint.hs"
        return "#{path} must pass '--hint=HLint.hints' to HLint" unless File.open(path) { |f| f.each_line.any? { |l| l.match(/HLint\.hints/) } }
      elsif bname == "HLint.hints"
        template = "#{File.dirname(__FILE__)}/HLint.hints"
        return "#{path} does not match template #{template}" unless FileUtils.compare_file(template, path)
      end
    end
  end
end
