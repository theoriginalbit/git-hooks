module Overcommit::Hook::CommitMsg
  # Ensures the commit message follows a specific format.
  class CommitTag < Base
    TAGS = ['NEW', 'ENHANCE', 'FIX', 'LOOKS', 'SPEED', 'QUALITY', 'DOC', 'CONFIG', 'TEST']

    def run
      error_msg = validate_pattern(commit_message_lines[0])
      return :fail, error_msg if error_msg

      :pass
    end

    private

    def validate_pattern(message)
      "Missing commit tag. Valid tags are #{TAGS.join(" ")}." unless TAGS.any? { |tag| message.start_with? tag }
    end
  end
end
