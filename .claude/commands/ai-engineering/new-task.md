---
description: Scaffold a new task file from the shared template into the host project's .claude/tasks/Pending/
argument-hint: <short task name>
---

Create a new task file for: $ARGUMENTS

Follow @../../../rules/task-management.md and @../../../rules/git-workflow.md.

1. Derive a short kebab-case `<slug>` from the task description, and a
   branch type — `feature`, `bugfix`, `hotfix`, `chore`, `refactor`, or
   `docs` — from what the task actually is. Ask if the type is genuinely
   ambiguous.
2. `git fetch origin`, then create the branch from the remote:
   `git checkout -b <type>/<slug> origin/master`. Never branch from local
   master or an existing feature branch.
3. If `.claude/tasks/Pending/` doesn't exist in this project yet, create it.
4. Copy the template from `ai-engineering/tasks/templates/task.md` (or
   `tasks/templates/task.md` if working inside the `ai-engineering` repo
   itself) into `.claude/tasks/Pending/<slug>.md`.
5. Fill in `Branch: <type>/<slug>`, `Objective`, and `Context` from
   `$ARGUMENTS` and anything already known from the current conversation.
   Leave `Investigation`, `Root Cause`, `Proposed Solution`, and
   `Implementation` empty for now.
6. Set `Status: Pending` and `Started:` to the current date/time if known.
7. Report the created branch name and file path.

Do not mark the task Approved or Done as part of this command.
