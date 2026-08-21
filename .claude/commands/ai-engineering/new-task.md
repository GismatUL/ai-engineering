---
description: Scaffold a new task file from the shared template into the host project's .claude/tasks/Pending/
argument-hint: <short task name>
---

Create a new task file for: $ARGUMENTS

Follow @../../../rules/task-management.md.

1. If `.claude/tasks/Pending/` doesn't exist in this project yet, create it.
2. Copy the template from `ai-engineering/tasks/templates/task.md` (or
   `tasks/templates/task.md` if working inside the `ai-engineering` repo
   itself) into `.claude/tasks/Pending/<slug>.md`, where `<slug>` is a
   short kebab-case name derived from the task description.
3. Fill in `Objective` and `Context` from `$ARGUMENTS` and anything already
   known from the current conversation. Leave `Investigation`,
   `Root Cause`, `Proposed Solution`, and `Implementation` empty for now.
4. Set `Status: Pending` and `Started:` to the current date/time if known.
5. Report the created file path.

Do not mark the task Approved or Done as part of this command.
