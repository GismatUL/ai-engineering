---
description: Move a task from .claude/tasks/Pending/ to .claude/tasks/Done/, filling completion metadata from actual evidence only
argument-hint: <task file name or task description>
---

Close the task: $ARGUMENTS

Follow @../../../rules/task-management.md. Before moving the task:

1. Confirm the required verification has actually been completed this
   session (tests run, static analysis, lint, manual check — whatever
   applies). If it has not, say so and do not close the task.
2. Fill in the `Verification` and `Completion` sections using only what was
   actually observed this session:
   - Status, Started/Completed timestamps, active work duration, elapsed
     duration — mark approximate or unknown rather than inventing a value.
   - Tests executed and their actual result.
   - Any remaining risks or blockers, listed under `Remaining Work`.
3. Move the file from `.claude/tasks/Pending/` to `.claude/tasks/Done/`.
4. Report the final file path and a one-line summary of what was verified.

Never fabricate a duration, test result, or verification status that
wasn't actually produced.
