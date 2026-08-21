# Testing & Static Analysis Rules

- Match the project's existing test framework — Pest if already in use,
  otherwise PHPUnit; do not introduce the other without asking.
- Cover the change's actual behavior: the happy path, the edge cases the
  change touches, and any regression the change could introduce.
- Run PHPStan/Psalm (whichever the project has configured) before
  considering a task done; do not lower the configured analysis level to
  make errors disappear.
- Do not delete or weaken an existing test to make a change pass — fix the
  code or the test's expectation, not the assertion's strictness.
- Prefer feature/integration tests for HTTP endpoints and unit tests for
  isolated business logic (services, value objects); do not unit-test
  framework glue.
- A task is not verified until the tests were actually run this session —
  never report a pass that wasn't observed.
