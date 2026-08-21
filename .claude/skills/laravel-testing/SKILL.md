---
name: laravel-testing
description: Use when asked to add or update tests for a Laravel change, or before marking a Laravel task done. Matches the project's existing test framework (Pest or PHPUnit) and runs static analysis (PHPStan or Psalm) as part of verification — never reports tests as passing without actually running them.
---

# Laravel Testing

Rules: @../../../rules/testing.md

## Steps

1. Detect the project's test framework (Pest vs. PHPUnit) and static
   analysis tool (PHPStan vs. Psalm) from its config/`composer.json` — do
   not assume.
2. Write feature/integration tests for HTTP endpoints and jobs/listeners;
   unit tests for isolated service/business logic. Cover the happy path,
   the edge cases the change touches, and any regression risk.
3. Run the test suite and the static analysis tool. Report actual results
   — do not report a pass that wasn't observed this session.
4. If a test or static analysis check fails, fix the code (or the test's
   expectation, if the test was wrong) — do not delete or weaken the check
   to make it pass.
