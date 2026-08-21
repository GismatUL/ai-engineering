---
description: Produce an implementation plan and validate it against existing architecture, without modifying code (phases 3-4 of the software-change workflow)
argument-hint: <task description, or reference to prior /ai-engineering:investigate output>
---

Run phases 3 ("Plan") and 4 ("Architecture Validation") of the
software-change workflow (@../../../workflows/software-change.md) for:

$ARGUMENTS

If this task hasn't been investigated yet this session, run the
investigation first (see `/ai-engineering:investigate`) before planning.

Produce a plan containing:

- Root cause
- Proposed solution
- Files to change
- Database changes (if any)
- Risks
- Backward-compatibility considerations
- Testing strategy

Then validate the plan against existing architecture, database constraints,
existing services/abstractions, and side effects — flag and revise any
unsafe assumption.

Do not modify code in this command. Present the plan for approval before
implementing.
