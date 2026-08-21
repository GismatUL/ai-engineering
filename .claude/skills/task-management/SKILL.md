---
name: task-management
description: Use when the user asks to create, update, move, or close a task file (e.g. "create a task for this", "mark this task done", "what's pending"). Manages task files through Pending -> In Progress -> Done using the shared template, and never invents completion metadata such as duration or test results that weren't actually produced.
---

# Task Management

Rules: @../../../rules/task-management.md
Template: @../../../tasks/templates/task.md

## Behavior

- Task files belong in the **host project's** `.claude/tasks/Pending/` and
  `.claude/tasks/Done/` (not inside this submodule) — see the rules file
  for why.
- New tasks are created from the template in `tasks/templates/task.md`,
  filed under `.claude/tasks/Pending/`.
- A task only moves to `.claude/tasks/Done/` once required verification
  (tests, static analysis, lint, or manual check as applicable) has
  actually been completed.
- Completion metadata (status, started/completed timestamps, active work
  duration, elapsed duration, verification status, tests executed,
  blockers) must reflect what was actually observed this session. If exact
  timing is unavailable, mark it approximate or unknown rather than
  inventing a value.
- Prefer the `/ai-engineering:new-task` and `/ai-engineering:close-task`
  commands for the mechanical file operations; use this skill's judgment
  for anything more ambiguous (merging duplicate tasks, deciding a task is
  blocked, etc.).
