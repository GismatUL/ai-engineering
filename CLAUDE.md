# AI Engineering System

## Purpose

This repository contains reusable AI engineering workflows, agents, skills,
rules, and task templates for software development projects.

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