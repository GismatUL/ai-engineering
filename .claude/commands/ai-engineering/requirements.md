---
description: Read a brief (PDF/spec), design reference, and owner instructions in full and produce a requirements checklist, without writing application code (phases 1-3 of the project-build workflow)
argument-hint: <brief path, design path/URL, and any owner instructions>
---

Run phases 1 ("Intake"), 2 ("Requirements"), and 3 ("Reconcile and
decide") of the project-build workflow
(@../../../workflows/project-build.md) for:

$ARGUMENTS

- Read every page of the brief; fall back to page images where text
  extraction is incomplete. Inspect the design reference and existing code.
- Fill in @../../../templates/requirements-checklist.md and save it as
  `docs/REQUIREMENTS.md` in the host project (ask before overwriting an
  existing one).
- Map each requirement to a screen, endpoint, entity, command, or config,
  and to how it will be verified. Mark confirmed vs. assumed.
- List conflicts between the owner's instructions and the brief, the
  recommended resolution for each, and the questions that block work.

Do not write application code in this command. Follow with the
`project-build` skill to implement.
