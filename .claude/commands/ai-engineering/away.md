---
description: Work through the queued tasks unattended while the user is away — no phase approvals, local commits on task branches, blockers recorded instead of asked, a report at the end
argument-hint: [time budget and priorities, e.g. "7 hours, checkout bug first"]
---

The user is away. Work autonomously following
@../../../rules/autonomous-mode.md, with these instructions from the user:

$ARGUMENTS

1. Check the setup. If `.claude/settings.local.json` / `.claude/settings.json`
   has no Stop hook running `away-stop`, or the routine test/build
   commands aren't allowed, say so in one line now and in the final
   report — then continue anyway.
2. Create `.claude/tasks/.away` containing `started=<current date/time>`.
3. Inspect the project state, git status, and every task in
   `.claude/tasks/Pending/` (create the folder if missing). List the
   queue in priority order in one short message, then start — do not
   wait for approval.
4. Work the queue per the rule file's work loop until no unblocked task
   remains or the time budget above is used up.
5. Write `.claude/tasks/away-report-<YYYY-MM-DD-HHMM>.md` as the rule file
   describes, then delete `.claude/tasks/.away`.
6. End with a short summary pointing to the report.

Never ask a question and wait for an answer during this run — record it
as a blocker and move on.
