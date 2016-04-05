module Overcommit::Hook::PrePush
  class BranchFormat < Base
    TAGS = ['feature', 'enhance', 'fix', 'looks', 'speed', 'quality', 'doc', 'config', 'test']

    def run
      messages = pushed_refs.map(&method(:invalid_msg)).compact
      return (messages.any? ? [:fail, messages.join("\n")] : :pass)
    end

    private

    def invalid_msg(pushed_ref)
      ref = pushed_ref.remote_ref.sub(/^refs\/heads\//, '')
      if ref == "master"
        return nil
      elsif ref !~ /^[a-z]+\/[a-z]+(?:-[a-z]+)*$/
        return "Remote ref should be of the form feature/something-new, not #{ref}"
      elsif not TAGS.any? { |tag| ref.start_with? tag }
        return "Remote ref should start with one of: " + TAGS.join(" ")
      end
    end
  end
end
