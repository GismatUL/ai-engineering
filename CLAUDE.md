# AI Engineering System

## Purpose

This repository contains reusable AI engineering workflows, agents, skills,
rules, and task templates for software development projects.

It self-hosts its own Claude Code native assets under `.claude/agents`,
`.claude/skills`, and `.claude/commands` — open this repo in Claude Code
and the `software-engineer` agent, the `software-change` / `project-bootstrap`
/ `task-management` skills, and the `/ai-engineering:*` commands are
available with no setup. See [README.md](README.md) for how to add this
repo as a submodule to another project so it works there too.

A Laravel/PHP specialization layer sits on top of that generic core: the
`laravel-engineer` agent and the `laravel-api` / `database-optimization` /
`laravel-testing` skills, backed by `rules/laravel.md`, `rules/database.md`,
`rules/testing.md`, and `rules/devops.md`.

## Core Principles

- Understand the existing project before modifying code.
- Never modify code before completing the required investigation.
- Preserve existing business behavior unless explicitly requested otherwise.
- Prefer the simplest solution that solves the actual problem.
- Follow existing project architecture and conventions.
- Apply SOLID, DRY, KISS and separation of concerns.
- Do not introduce unnecessary dependencies or infrastructure.
- Do not make assumptions about unknown infrastructure or database state.
- Clearly distinguish verified facts from assumptions.
- Measure performance before claiming performance improvements.
- Security and backward compatibility must be considered before implementation.
- Every task is implemented on its own `feature/`/`bugfix/`/`hotfix/`/etc.
  branch created from `origin/master` — never commit directly to master
  (see `rules/git-workflow.md`).

## Workflow

For non-trivial tasks:

1. Understand
2. Investigate
3. Plan
4. Validate architecture
5. Implement
6. Test
7. Review
8. Verify

Do not skip investigation or validation for complex changes.

## Coding Rules

- Do not add unnecessary comments.
- Do not rewrite unrelated code.
- Do not commit without approval.
- Keep changes focused on the task.
- Reuse existing project patterns where appropriate.
- Avoid premature abstraction.
- Avoid speculative features.