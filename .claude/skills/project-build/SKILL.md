---
name: project-build
description: Use when asked to build an application or a large feature set from a brief — a developer brief/spec (often a PDF), a design prototype (Figma or its export), and owner instructions — rather than to change existing behavior. Reads every source in full, produces a requirements checklist, records decisions and conflicts, builds every in-scope workflow end to end, verifies with real tests, two-user authorization checks, and an end-to-end run, and delivers documentation and an implementation report. Use software-change instead for a change to an existing feature.
---

# Project Build

Full phase definitions: @../../../workflows/project-build.md
Supporting rules: @../../../rules/security.md,
@../../../rules/integrations.md, @../../../rules/documentation.md,
@../../../rules/architecture.md, @../../../rules/git-workflow.md,
@../../../rules/measurement.md
Templates: @../../../templates/requirements-checklist.md,
@../../../templates/implementation-report.md

## How to run this skill

1. **Intake** — run the `project-bootstrap` skill if the project hasn't
   been explored this session. Then read the brief in full, inspect the
   design reference, and record what already exists.
2. **Requirements** — write the requirements checklist into the host
   project's `docs/` and show it. Continue into implementation unless a
   genuine blocker needs the owner's input.
3. **Reconcile** — log owner/brief conflicts and decisions in the
   implementation report as they happen, not at the end.
4. **Architecture → Implement** — on a `feature/` branch off
   `origin/master`. Build workflows end to end; no mock data, no silently
   dropped requirements.
5. **Verify** — run every check the environment supports, including the
   two-user authorization check and an end-to-end run. Report only
   results that were observed.
6. **Document and report** — README, operator guide, user brief, the
   final checklist, and the implementation report.

A switch to a different framework or a major new dependency is proposed
and approved before it happens, and recorded in the decision log.
