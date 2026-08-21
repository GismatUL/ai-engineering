---
name: software-change
description: Use for any non-trivial code change request in the host project — new features, bug fixes, refactors, or performance work that touches more than a couple of files, has more than one valid approach, or affects existing behavior. Runs the change through eight explicit phases (understand, investigate, plan, validate architecture, implement, test, review, final verification) instead of jumping straight to code. Skip for single-line fixes, typos, or changes the user has already fully specified.
---

# Software Change Workflow

Full phase definitions: @../../../workflows/software-change.md
Supporting rules: @../../../rules/architecture.md,
@../../../rules/coding-standards.md, @../../../rules/security.md

## How to run this skill

1. **Understand** — inspect the host project's structure, relevant modules,
   existing architecture, conventions, and related implementations. If this
   looks like the first time working in this project, invoke the
   `project-bootstrap` skill first.
2. **Investigate** — trace the full execution flow, dependencies, database
   interactions, external integrations, performance and security concerns.
   Explicitly separate verified facts from assumptions.
3. **Plan** — produce a plan: root cause, proposed solution, files to
   change, database changes, risks, backward-compatibility considerations,
   testing strategy. Do not modify code yet.
4. **Validate architecture** — check the plan against existing architecture,
   database constraints, existing services/abstractions, side effects and
   events. Reject or revise unsafe assumptions.
5. **Implement** — only after validation. Keep changes focused, follow
   project conventions, do not introduce unnecessary architecture.
6. **Test** — run relevant tests, add missing tests where appropriate, test
   edge cases and backward compatibility.
7. **Review** — check correctness, security, performance, maintainability,
   SOLID/DRY/KISS, regression risk.
8. **Final verification** — report what changed, why, tests executed,
   remaining risks, and anything that could not be verified.

For changes that are genuinely simple (single-line fix, typo, something the
user has already fully specified down to the exact edit) it is fine to
collapse phases 1–4 into a brief internal check rather than producing a
formal plan — but never skip straight to editing code on anything with more
than one reasonable approach.
