# Documentation Rules

Applies when a project is built or substantially extended, or when its
setup, operation, or security model changes. Write for three audiences, in
separate documents — do not mix them.

## README (developers and deployers)

- What the application is and what it deliberately does not do.
- Architecture: components, a request/data-flow diagram, and a table
  mapping key directories/classes to responsibilities.
- Why non-obvious design choices were made (e.g. a framework feature that
  was deliberately avoided).
- Prerequisites with the versions actually tested — and the supported
  versions that were not.
- Setup: dependencies, environment variables (where each is documented),
  database creation with a least-privilege user, migrations, keys.
- How accounts are provisioned when there is no self-service.
- Integrations (email, storage, third-party APIs): configuration and a
  safe test procedure.
- Running locally, production deployment, backups and restore testing.
- How to run the tests, and what they cover.
- How data is stored and protected, including what is **not** covered.
- Known limitations, or a link to the implementation report.

## Operator guide (whoever runs the app day to day)

- Commands for the actual machine it runs on (full binary paths when the
  default on PATH is the wrong version).
- Starting the app, account tasks, housekeeping jobs, configurable limits
  and where to change them, key/secret custody, troubleshooting as a
  problem → fix table.

## User brief (end users)

- Short, task-oriented, no internals: sign in, the main workflows step by
  step, what the other party sees, and the few things that matter (e.g.
  retention, sending a password through a separate channel).

## Rules

- Document only what exists and was verified; label samples and runbooks
  as such.
- Never put secrets in documentation — say where they live instead.
- Keep the requirements checklist and implementation report
  (`templates/`) up to date when scope or decisions change.
