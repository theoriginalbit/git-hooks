module Overcommit::Hook::CommitMsg
  # Ensures the commit message follows a specific format.
  class Imperative < Base
    # From https://github.com/m1foley/fit-commit/blob/master/lib/fit_commit/validators/tense.rb
    # (c) 2015 Mike Foley, MIT License
    VERB_BLACKLIST = %w(
      adds       adding       added
      allows     allowing     allowed
      amends     amending     amended
      bumps      bumping      bumped
      calculates calculating  calculated
      changes    changing     changed
      cleans     cleaning     cleaned
      commits    committing   committed
      corrects   correcting   corrected
      creates    creating     created
      darkens    darkening    darkened
      disables   disabling    disabled
      displays   displaying   displayed
      drys       drying       dryed
      ends       ending       ended
      enforces   enforcing    enforced
      enqueues   enqueuing    enqueued
      extracts   extracting   extracted
      finishes   finishing    finished
      fixes      fixing       fixed
      formats    formatting   formatted
      guards     guarding     guarded
      handles    handling     handled
      hides      hiding       hid
      increases  increasing   increased
      ignores    ignoring     ignored
      implements implementing implemented
      improves   improving    improved
      keeps      keeping      kept
      kills      killing      killed
      makes      making       made
      merges     merging      merged
      moves      moving       moved
      permits    permitting   permitted
      prevents   preventing   prevented
      pushes     pushing      pushed
      rebases    rebasing     rebased
      refactors  refactoring  refactored
      removes    removing     removed
      renames    renaming     renamed
      reorders   reordering   reordered
      requires   requiring    required
      restores   restoring    restored
      sends      sending      sent
      sets       setting
      separates  separating   separated
      shows      showing      showed
      skips      skipping     skipped
      sorts      sorting
      speeds     speeding     sped
      starts     starting     started
      supports   supporting   supported
      takes      taking       took
      tests      testing      tested
      truncates  truncating   truncated
      updates    updating     updated
      uses       using        used
    )

    def run
      first_line = commit_message_lines[0]
      first_word = (first_line.split(':')[1] || first_line).split.first(2).detect { |w| w =~ /\A\w/ }
      return :fail, "Message must use imperative present tense" if first_word && VERB_BLACKLIST.include?(first_word.downcase)

      :pass
    end
  end
end
