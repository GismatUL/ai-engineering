# Task Management

## Task Lifecycle

Tasks should move through:

Pending → In Progress → Awaiting Approval → Done

A task must not be marked Done until the required verification has been completed.

## Approval Moves a Task to Done

Only the user's explicit approval of the finished work moves a task to
`Done/`. Passing verification is required but not sufficient:

1. When implementation and verification are complete, set
   `Status: Awaiting Approval`, record the evidence, and leave the file in
   `Pending/`. Ask the user to review.
2. When the user approves the task ("approved", "looks good, close it",
   etc.), fill in the `Completion` section, set `Status: Done`, tick
   `Completion approved`, and move the file from `Pending/` to `Done/` in
   the same step — don't wait to be asked to move it.
3. If the user requests changes instead, set `Status: In Progress` and keep
   the file in `Pending/`.

Approval of the plan (`## Approval` → `Approved (plan)`) is a separate gate
and never moves a task to `Done/`. Never move a task to `Done/` on your own
judgment, in away mode, or just because verification passed.

A task that can't proceed without the user stays in `Pending/` with
`Status: Blocked` and the open question under `## Blocked`. Away mode
(`autonomous-mode.md`) skips blocked tasks.

Every task is implemented on its own branch, created from `origin/master`
before any code is touched — see `git-workflow.md` for branch naming and
rules. Record the branch name in the task file's `Branch:` field.

## Completion Metadata

Completed tasks should record, when known:

- Status
- Started date/time
- Completed date/time
- Active work duration, if known
- Elapsed duration
- Verification status
- Tests executed
- Important blockers or limitations

Never invent task duration or verification results.

If exact duration is unavailable, mark it as approximate or unknown.

## Task Files

Task files live in the **consuming project**, not inside this
`ai-engineering` submodule — the submodule is shared, versioned content and
must not accumulate host-project-specific task state.

Pending tasks belong in:

.claude/tasks/Pending/

Completed tasks belong in:

.claude/tasks/Done/

If the host project already keeps tasks elsewhere (for example
`tasks/Pending/` and `tasks/Done/` at the project root), use that existing
location instead — the lifecycle and approval rule are the same.

Use the task template from this submodule:

ai-engineering/tasks/templates/task.md

(When working inside the `ai-engineering` repo itself, `tasks/templates/`
is the template source and `tasks/Pending/` / `tasks/Done/` under this
repo's own root serve the same role for its own self-hosted use.)