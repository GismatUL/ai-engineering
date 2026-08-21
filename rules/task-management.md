# Task Management

## Task Lifecycle

Tasks should move through:

Pending → In Progress → Done

A task must not be marked Done until the required verification has been completed.

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

Use the task template from this submodule:

ai-engineering/tasks/templates/task.md

(When working inside the `ai-engineering` repo itself, `tasks/templates/`
is the template source and `tasks/Pending/` / `tasks/Done/` under this
repo's own root serve the same role for its own self-hosted use.)