---
description: Understand and investigate a task without proposing a plan or touching code (phases 1-2 of the software-change workflow)
argument-hint: <task description>
---

Run phases 1 ("Understand") and 2 ("Investigate") of the software-change
workflow (@../../../workflows/software-change.md) for the following task:

$ARGUMENTS

- Inspect the relevant project structure, modules, architecture, and
  conventions.
- Trace the complete execution flow related to the task.
- Identify dependencies, database interactions, external integrations, and
  performance/security concerns.
- Explicitly separate **verified** facts from **inferred** and **unknown**
  ones.

Do not propose a solution or modify any code in this command — report
findings only. Follow with `/ai-engineering:plan-change` once investigation
is complete.
