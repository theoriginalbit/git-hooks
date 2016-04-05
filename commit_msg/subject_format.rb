module Overcommit::Hook::CommitMsg
  # Ensures the commit subject follows a specific format.
  class SubjectFormat < Base
    def run
      error_msg = validate_pattern(commit_message_lines[0])
      return :fail, error_msg if error_msg

      :pass
    end

    private

    def validate_pattern(subject)
      "Subject must be of form 'TAG: My message'" unless subject =~ /[A-Z]+: [^a-z\s].+/
    end
  end
end
