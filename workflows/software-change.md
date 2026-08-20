# Software Change Workflow

## Phase 1 — Understand

- Inspect the project structure.
- Identify the relevant modules.
- Identify existing architecture and conventions.
- Identify related implementations.

## Phase 2 — Investigate

- Trace the complete execution flow.
- Identify dependencies.
- Identify database interactions.
- Identify external integrations.
- Identify performance and security concerns.
- Separate verified facts from assumptions.

## Phase 3 — Plan

Create an implementation plan containing:

- Root cause
- Proposed solution
- Files to change
- Database changes
- Risks
- Backward compatibility considerations
- Testing strategy

Do not modify code yet.

## Phase 4 — Architecture Validation

Before implementation:

- Validate the proposed design against the existing architecture.
- Check database constraints.
- Check existing services and abstractions.
- Check side effects and events.
- Identify potential regressions.
- Reject or revise unsafe assumptions.

## Phase 5 — Implementation

Only after validation:

- Implement the approved plan.
- Keep changes focused.
- Follow project conventions.
- Do not introduce unnecessary architecture.

## Phase 6 — Testing

- Run relevant tests.
- Add missing tests where appropriate.
- Test edge cases.
- Test backward compatibility.

## Phase 7 — Review

Review the implementation for:

- correctness
- security
- performance
- maintainability
- SOLID
- DRY
- KISS
- regression risks

## Phase 8 — Final Verification

Report:

- What changed
- Why it changed
- Tests executed
- Remaining risks
- Anything that could not be verified