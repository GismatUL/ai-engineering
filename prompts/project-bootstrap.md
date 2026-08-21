# Project Bootstrap Prompt

Use this when starting work in a project for the first time (or after a
long gap) — before touching any task, build a short factual brief so later
work reuses real conventions instead of guessing.

## Steps

1. **Identify the stack** — language(s), framework(s), package manager,
   build/test/lint commands. Read config files (`package.json`,
   `composer.json`, `pyproject.toml`, `go.mod`, etc.) rather than assuming.
2. **Identify structure** — where source, tests, migrations, and config
   live; how modules/packages are organized.
3. **Identify conventions** — naming, formatting, error handling,
   dependency injection style, testing patterns. Look at a few existing
   files doing similar work rather than inferring from the framework's
   defaults alone.
4. **Identify architecture** — layering (controllers/services/repositories
   or equivalent), how data flows in and out, notable existing
   abstractions. Do not assume a pattern is used unless you see it.
5. **Identify constraints** — CI checks, required tests, lint/static
   analysis tools that must pass, anything in an existing CLAUDE.md/README
   describing house rules.
6. **Report the brief** — a short summary (stack, structure, conventions,
   architecture, constraints), explicitly marking anything inferred rather
   than confirmed. Do not start implementation work in this step.

## Output

A concise project brief, not an essay. Enough for the `software-engineer`
agent and `software-change` skill to act consistently with the project
afterward — not a full architecture document.
