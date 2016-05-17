require 'pathname'

module Overcommit::Hook::PreCommit
  # If any file in 'files' is changed, all must be.
  class ChangeTogether < Base
    def run
      root = Pathname.new(execute(%w[git rev-parse --show-toplevel]).stdout.strip)
      relative = applicable_files.map { |f| Pathname.new(f).relative_path_from(root).to_s }

      modified = relative.select { |f| to_check.include? f }
      if not modified.empty?
        unmodified = to_check.select { |f| not relative.include? f }
        if not unmodified.empty?
          msg = "Modified #{modified} but not #{unmodified}"
          msg += "; #{config['message']}" if config['message']
          return [:fail, msg]
        end
      end

      return :pass
    end

    private

    def to_check
      @to_check ||= Array(config['files'])
    end
  end
end
