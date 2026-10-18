# Git Workflow Rules

- Every task gets its own branch, created from the latest **remote**
  master (`origin/master`) — never from local master (which may be stale)
  and never stacked on top of another task's branch.
- Branch naming: `<type>/<short-kebab-case-description>`, matching the
  task's slug where one exists, e.g. `feature/export-streaming`,
  `bugfix/n-plus-one-nova-index`.
- Branch types:
  - `feature/` — new functionality or enhancement.
  - `bugfix/` — non-urgent fix for existing broken behavior.
  - `hotfix/` — urgent fix targeting production; still branches from
    master and still gets its own branch, even when it skips the normal
    task queue.
  - `chore/` — tooling, dependencies, CI, config; no user-facing behavior
    change.
  - `refactor/` — internal restructuring with no behavior change.
  - `docs/` — documentation only.
- Before branching: `git fetch origin`, then branch explicitly from
  `origin/master` — `git checkout -b <type>/<name> origin/master`.
- Never commit directly to master.
- One task = one branch. If a task's scope grows into unrelated work,
  start a new task and a new branch rather than expanding the existing
  one.
- In away mode (`autonomous-mode.md`), commit locally on the task branch
  before switching to the next task; never push or merge unattended.
- Creating or closing a task file does not merge, push, or delete the
  branch — merging/PR review is a separate, explicit step outside this
  workflow.
