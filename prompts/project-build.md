# Project Build Prompt

A kickoff prompt for building an application from a brief. Copy it into the
host project (e.g. `docs/kickoff.md`), fill in the placeholders, and hand
it to Claude Code. The process it triggers is `workflows/project-build.md`.

Keep real credentials out of this file — reference where they live
(`.env`, a password manager entry) instead of pasting them.

---

Act as a senior full-stack engineer, software architect, and application
security engineer. Build **{{PROJECT_NAME}}** from the brief, design, and
owner instructions below. Do not start coding blindly: understand the
requirements and the existing code first, then implement systematically,
following `workflows/project-build.md`.

## Sources

- Brief: `{{BRIEF_PATH}}` — the primary source of functional and technical
  requirements. Read every page.
- Design: `{{DESIGN_PATH_OR_URL}}` — the visual and interaction reference.
  {{DESIGN_ACCESS_NOTES}} (prototype access only — never production
  credentials or a hardcoded login).
- Existing code/assets: `{{EXISTING_PATHS}}`

## Owner instructions

{{OWNER_NAME}} confirmed:

- Purpose: {{PURPOSE}}
- Backend: {{BACKEND_STACK_AND_VERSIONS}}
- Frontend: {{FRONTEND_STACK}}
- Database: {{DATABASE}}
- {{HARD_CONSTRAINTS — e.g. "no admin panel; users are provisioned by an operator"}}
- {{INTEGRATIONS — e.g. "reuse the SMTP configuration of <other app> for testing"}}

Reconcile these with the brief. Where they conflict, prefer the explicit
instruction unless the brief documents a later decision, and record the
conflict. Do not assume a framework the owner did not ask for.

## Hard constraints

For each constraint above, state what it rules out, e.g. for "no admin
panel": no admin dashboard, no user-management screen, no public
registration; instead, a documented, secure way for an operator to
provision accounts (CLI command, or SQL with a properly generated password
hash); no default accounts; hiding an admin URL is not a security control.
If the brief requires something a constraint forbids, stop on that item
and report the discrepancy.

## Security

The owner's priority is eliminating security risk. Apply
`rules/security.md` throughout, not as a final pass. Inspect existing
authentication and security code before changing it.

## Deliverables

1. Requirements checklist (`templates/requirements-checklist.md`), mapped
   to screens, endpoints, entities, and tests.
2. A working application — every in-scope workflow end to end.
3. Tests and an end-to-end run, with actual results.
4. Documentation per `rules/documentation.md`.
5. Implementation report (`templates/implementation-report.md`).

## Working rules

- Work in the existing project directory; inspect before modifying;
  preserve working code and user changes.
- Do not rebuild unnecessarily, ship mock functionality, silently omit a
  requirement, invent credentials, or claim anything works without having
  verified it.
- Ask a focused question only for a genuinely blocking ambiguity;
  otherwise proceed autonomously through analysis, implementation,
  testing, and documentation.

Start by inspecting the project directory, reading the brief in full, and
producing the requirements checklist. Then continue into implementation
without stopping, unless a genuine blocker needs input.
