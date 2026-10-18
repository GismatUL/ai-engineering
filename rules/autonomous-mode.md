# Autonomous Mode Rules

Applies while the user is away and Claude works unattended (started with
`/ai-engineering:away` or `prompts/autonomous-mode.md`). Everything else in
`rules/` still applies; this file only changes what needs approval and
how work is chosen, recorded, and stopped.

## Setup (done by the user before leaving)

- Queue the work as task files in `.claude/tasks/Pending/`. Queuing a task
  approves implementing it within its stated objective, unless the task
  says it needs approval first.
- Merge `settings/away-mode.json` into the host project's
  `.claude/settings.local.json`, so routine commands don't stop on a
  permission prompt, destructive ones are denied outright, and the Stop
  hook keeps the session going while unblocked tasks remain.
- Keep the machine awake (power settings: never sleep on AC, lid close
  does nothing), or run in a cloud session instead.

## Marker

`.claude/tasks/.away` marks an active run. The Stop hook
(`.claude/hooks/away-stop.sh` / `.ps1`) only acts while it exists. Create
it at the start, delete it at the very end, after the report is written.

## Work loop

1. Inspect the project state, git status, and each Pending task's notes
   before starting — continue existing work, never restart or redo
   completed phases.
2. Pick the highest-priority unblocked task (explicit priority first,
   then dependencies, then the order given by the user).
3. Branch from `origin/master` per `rules/git-workflow.md`, or check out
   the task's existing branch.
4. Run the task through `workflows/software-change.md` (or
   `workflows/project-build.md`) without pausing for phase approvals.
5. Verify: run the relevant tests, builds, and static analysis; fix
   failures and rerun. Report only results that were observed.
6. Commit on the task branch, update the task file, and move it to
   `.claude/tasks/Done/` only when verification passed.
7. Continue with the next task.

When the queue is empty, look for unfinished in-scope work recorded in the
project (requirements checklist, implementation report, TODOs in task
notes) and queue it as new task files. Do not invent features.

## Allowed without approval

- Creating task branches from `origin/master` and switching between them.
- Local commits on the task's own branch (commit before switching
  branches; never leave work uncommitted between tasks).
- Running tests, builds, linters, static analysis, and the app locally.
- Installing dependencies from the existing lockfile; adding a dependency
  only when the task requires it, recorded as a decision.
- Migrations against the local development database.

## Never without approval

- `git push`, merging, rebasing shared branches, committing to master,
  rewriting history, `reset --hard`, `clean`, deleting branches.
- Destructive database commands (`migrate:fresh`, `db:wipe`, dropping
  tables), anything touching a production or shared database.
- Deploying, changing CI/CD or infrastructure, contacting real users or
  customers (`rules/integrations.md`).
- Reading, printing, or changing secrets (`.env`, keys, credentials).
- Deleting files or work that the task did not create.
- Expanding a task beyond its objective — queue the extra work as a new
  Pending task instead.

## Decisions and blockers

- Make reasonable technical decisions from the requirements and codebase
  and record each one in the task's `## Notes` with the reason.
- A decision that is genuinely the user's (business behavior, security
  trade-off, scope, cost): write the question under the task's
  `## Blocked`, set `Status: Blocked`, and move to another task. Take the
  safe option and continue only if it is clearly reversible.
- A failure that three distinct fix attempts did not resolve is a
  blocker: record what was tried, the exact error, and set
  `Status: Blocked`.
- Never ask a question and wait — nobody will answer until the user
  returns.

## Progress log

Append to the task's `## Notes` as work happens — what was done, decided,
and verified, with timestamps — so the state survives a context
compaction or a crashed session.

## Ending the run

Stop when no unblocked task remains or the user's time budget is used up.
Then write `.claude/tasks/away-report-<YYYY-MM-DD-HHMM>.md`: tasks
completed (branch, commits, verification actually run), tasks blocked
(with the questions), tasks not started, decisions made, and anything
left in a risky state. Delete `.claude/tasks/.away` last.
