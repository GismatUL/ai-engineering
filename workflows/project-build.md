# Project Build Workflow

For building an application, or a large feature set, from a brief: a
developer brief/spec (often a PDF), a design prototype (Figma or an export
of it), and instructions from the project owner. Use
`software-change.md` instead for a change to existing behavior.

## Phase 1 — Intake

- Inspect the working directory, archives, and git status. Preserve
  existing files and user changes; never reset or discard them. Extract an
  archive next to itself without overwriting the original.
- Read the brief **in full** — every page, table, diagram, and screenshot.
  If text extraction is incomplete, look at the page images. Never work
  from the filename or a partial read.
- Inspect the design reference (prototype, exported code, screenshots) for
  screens, navigation, forms, tables, dialogs, and states. If it is
  inaccessible, continue from the brief and record the limitation.
- Treat the brief and design export as read-only reference material — do
  not edit them.
- Inspect any existing code, schema, dependencies, docs, and tests. Decide
  whether there is a partial implementation to build on or only a starter.
- Check which runtime, database, and tool versions are actually available,
  and compare them with what the brief requires (see
  `prompts/project-bootstrap.md`).

## Phase 2 — Requirements

- Produce a requirements checklist from
  `templates/requirements-checklist.md`: every requirement from the brief
  and the owner, mapped to where it will live (screen, endpoint, entity,
  command, config) and how it will be verified.
- Do not invent requirements. Mark each item as confirmed (brief/owner) or
  assumed.
- Record what is out of scope and who agreed to it.

## Phase 3 — Reconcile and decide

- When the owner's explicit instruction conflicts with the brief, prefer
  the instruction unless the brief documents a later decision — and record
  the conflict and the outcome.
- When a requirement conflicts with a hard constraint (e.g. the brief asks
  for an admin screen the owner ruled out), stop on that item and ask; do
  not build the conflicting part.
- Record every decision, especially one that deviates from the brief, in
  the decision log of `templates/implementation-report.md`, with the date
  and who decided.
- Ask a focused question only for a genuinely blocking ambiguity; otherwise
  make the reasonable call, record it, and continue.

## Phase 4 — Architecture

- Follow the existing architecture and the stack the owner requested. Do
  not add a framework or major dependency without a clear reason; if one
  is warranted, propose it and get approval before switching.
- Before relying on a framework convenience, check its security and data
  side effects (e.g. where it stores temporary files, which protections it
  relaxes by default) against `rules/security.md`.
- Design the schema explicitly: keys, foreign keys, and the indexes the
  known query patterns need, as migrations or a repeatable schema file.
- Plan security controls up front, per `rules/security.md` — not as a
  final pass.

## Phase 5 — Implement

- Build every in-scope workflow end to end. A button with no working
  backend is not a feature; mock data does not ship.
- When a feature depends on a missing credential or external service,
  implement the integration, document the exact configuration it needs,
  and report it as unverified (see `rules/integrations.md`).
- Do not silently drop a requirement — implement it, or list it as not
  done with the reason.
- Never add default accounts, hardcoded passwords, or auth bypasses, even
  for convenience during development.

## Phase 6 — Verify

Run every check the environment supports and record the actual results:

- Syntax/lint, static analysis, type check, production builds.
- The automated test suite, including tampering/abuse cases for any
  security-critical code.
- Authorization with **at least two users**: user B must get nothing from
  any of user A's endpoints, actions, or files.
- An end-to-end run through the real UI against a real (development)
  database and services, covering the main workflows and the error,
  empty, loading, and success states.
- External integrations only against safe targets (`rules/integrations.md`).
- Each runtime version the project claims to support. A version that
  could not be tested is listed as not verified.

Use a development database. Never run destructive commands against an
existing or production database.

## Phase 7 — Document and report

- Write the project documentation described in `rules/documentation.md`.
- Fill in `templates/implementation-report.md`: what was there at the
  start, decisions, what was built, files, schema, security controls,
  tests actually executed with results, what is not verified, what is not
  implemented, and open questions for the owner.
- Update the requirements checklist with each item's final status.
