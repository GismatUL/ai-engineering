# AI Engineering System

A reusable Claude Code workflow: a stack-agnostic core (agent, skills,
slash commands) that forces any non-trivial change through **investigate →
plan → validate → implement → test → review → verify** before code gets
written, plus a **Laravel/PHP specialization layer** on top for backend
work — API design, query optimization, queues/events, auth, testing, and
the DevOps around a Laravel app.

Drop it into any project as a git submodule and Claude Code runs it there
too. This repo also self-hosts the same assets at its own root, so cloning
and opening it in Claude Code demonstrates it working with zero setup.

## Why

Letting an AI agent edit code on the first prompt is fast and occasionally
wrong in expensive ways — silently changed behavior, invented APIs,
assumptions about a database or infra state nobody checked. The fix isn't
to slow the agent down everywhere; it's to make the *expensive* changes go
through explicit phases (with verified/inferred/unknown clearly separated)
while trivial ones stay a one-shot edit. That discipline is what's encoded
here, as something reusable across projects rather than re-typed into every
prompt.

## Architecture

```
 CLAUDE.md ─────────────┐
                         │  loaded automatically by Claude Code
 .claude/                │
 ├── agents/              │  WHO: a persona with judgment
 │   ├── software-engineer.md      (generic, stack-agnostic)
 │   └── laravel-engineer.md       (PHP/Laravel specialist)
 ├── skills/               │  WHEN: auto-triggered by request shape
 │   ├── software-change/SKILL.md          ┐ generic
 │   ├── project-build/SKILL.md            ┤ core
 │   ├── project-bootstrap/SKILL.md        ┤
 │   ├── task-management/SKILL.md          ┘
 │   ├── laravel-api/SKILL.md              ┐ Laravel
 │   ├── database-optimization/SKILL.md    ┤ specialization
 │   └── laravel-testing/SKILL.md          ┘
 └── commands/             │  WHAT: explicit /slash-command entry points
     └── ai-engineering/
         ├── investigate.md
         ├── plan-change.md
         ├── requirements.md
         ├── away.md
         ├── new-task.md
         └── close-task.md
                         │
                         ▼
 rules/  workflows/  templates/  tasks/templates/   ← shared knowledge, referenced
                                                        via @-imports, not duplicated
```

- **`rules/`** — two layers, both single sources of truth referenced via
  `@` imports rather than restated:
  - generic: `architecture.md`, `coding-standards.md`, `security.md`,
    `task-management.md`, `git-workflow.md`, `measurement.md`,
    `logging-and-monitoring.md`, `integrations.md`, `documentation.md`,
    `autonomous-mode.md`
  - Laravel/PHP: `laravel.md`, `database.md`, `testing.md`, `devops.md`
- **`workflows/software-change.md`** — the 8-phase process definition for
  changing existing code.
- **`workflows/project-build.md`** — the process for building an
  application from a brief, design, and owner instructions: intake,
  requirements checklist, decision log, end-to-end build, verification
  (including a two-user authorization check), documentation, report.
  `prompts/project-build.md` is a fill-in kickoff prompt for it, and
  `templates/` holds the requirements checklist and implementation report.
- **`.claude/agents/software-engineer.md`** — a subagent with the judgment
  to run that process end to end, for any stack.
- **`.claude/agents/laravel-engineer.md`** — the same discipline specialized
  for a PHP/Laravel backend: Eloquent/query optimization, Sanctum/OAuth2/JWT
  auth, queues/events/Horizon, Nova, and the Docker/CI/CD/AWS around it.
- **`.claude/skills/`** — auto-triggered wrappers: generic workflow
  (`software-change`), building from a brief (`project-build`),
  first-time-in-this-project brief
  (`project-bootstrap`), task file lifecycle (`task-management`); plus
  Laravel-specific ones for REST API design (`laravel-api`), measured query
  optimization (`database-optimization`), and Pest/PHPUnit + PHPStan/Psalm
  verification (`laravel-testing`).
- **`.claude/commands/ai-engineering/`** — explicit, narrower entry points
  (`/ai-engineering:investigate`, `/ai-engineering:plan-change`,
  `/ai-engineering:requirements`, `/ai-engineering:new-task`, `/ai-engineering:close-task`) for when you
  want one phase on demand instead of the full skill.

## Quickstart

### Use it here (self-hosted)

Clone this repo and open it in Claude Code — `.claude/agents`,
`.claude/skills`, and `.claude/commands` are already at the root, so
everything is live immediately.

### Use it in another project (submodule)

Claude Code only auto-loads `.claude/` from a project's own root, not from
a submodule's nested copy — so adding the submodule alone doesn't wire
anything up. Run the install script once to project this repo's native
assets into the host project:

```bash
git submodule add <this-repo-url> ai-engineering
./ai-engineering/install.sh          # or .\ai-engineering\install.ps1 on Windows
```

This copies `.claude/agents`, `.claude/skills`, and `.claude/commands` into
the host project's `.claude/`, and appends `@ai-engineering/rules/*.md`
imports to the host's `CLAUDE.md` (idempotent — safe to re-run any time the
submodule is updated). Pass `--symlink` / `-Symlink` instead of the default
copy if you want upstream edits to apply without re-running install.

### Keep it out of the host repo's git history (client/company projects)

If you're using this on a project whose repo you don't want to touch —
client work, a company monorepo, anything you'll push somewhere you don't
control — use `--local` / `-Local`:

```bash
git clone <this-repo-url> ai-engineering   # a plain clone, not `git submodule add`
./ai-engineering/install.sh --local        # or .\ai-engineering\install.ps1 -Local
```

This writes the rules imports to `CLAUDE.local.md` instead of `CLAUDE.md`
(Claude Code auto-loads it; it's meant to be gitignored, and is never
created or touched otherwise) and appends every path it installs —
`CLAUDE.local.md`, the `.claude/agents|skills|commands` files, and the
clone directory itself — to `.git/info/exclude`, a per-clone ignore file
that lives only in your local `.git/` folder and is never committed or
pushed. Re-running is idempotent; nothing shows up in `git status`.

This only works cleanly with a **plain `git clone`**, not `git submodule
add` — that command stages `.gitmodules` and a gitlink the moment you run
it, before install.sh ever touches anything, and `--local` can't undo that.

## The workflow

1. **Understand** — project structure, relevant modules, existing
   architecture and conventions.
2. **Investigate** — full execution flow, dependencies, DB/external
   integrations, performance/security concerns. Verified vs. inferred vs.
   unknown, explicitly.
3. **Plan** — root cause, proposed solution, files to change, risks,
   backward-compatibility, test strategy. No code yet.
4. **Validate architecture** — check the plan against what actually exists;
   reject unsafe assumptions.
5. **Implement** — only the approved scope, following project conventions.
6. **Test** — run and add tests, cover edge cases and backward compat.
7. **Review** — correctness, security, performance, maintainability.
8. **Verify** — report what changed, why, what was tested, what remains
   unverified.

Trivial changes (typos, single-line fixes, something already fully
specified) skip straight to implementation — the discipline is for changes
where guessing wrong is costly.

## Working while you're away

`/ai-engineering:away` lets Claude work through the queued tasks
unattended — no phase approvals, local commits on each task's branch,
questions recorded as blockers in the task file instead of asked, and an
away report at the end. The rules are in `rules/autonomous-mode.md`.

A prompt alone doesn't keep a session running, so set up three things
first:

1. **Queue the work** as task files in `.claude/tasks/Pending/`
   (`/ai-engineering:new-task`). Queuing a task approves implementing it.
2. **Merge `settings/away-mode.json` into the host project's
   `.claude/settings.local.json`.** It allows routine git/test/build
   commands so the run doesn't stop on a permission prompt, denies
   push/merge/destructive commands and `.env` access outright, and adds a
   Stop hook (`.claude/hooks/away-stop.sh`, installed by `install.sh`)
   that keeps the session working while unblocked tasks remain. On
   Windows without Git Bash, point the hook at `away-stop.ps1` instead:
   `powershell -NoProfile -ExecutionPolicy Bypass -File "$CLAUDE_PROJECT_DIR/.claude/hooks/away-stop.ps1"`.
   Adjust the allow list to the project's own commands.
3. **Keep the machine awake** (never sleep on AC power, lid close does
   nothing), or run the session in the cloud.

Then run `/ai-engineering:away 7 hours, checkout bug first`. Where the
command isn't installed (a cloud or headless session),
`prompts/autonomous-mode.md` is the paste-in equivalent.

The hook only acts while `.claude/tasks/.away` exists, so it doesn't
affect normal sessions, and it gives up after 30 forced continues so a
stuck run can still end.

## Git workflow

Every task gets its own branch, created from `origin/master`, named
`<type>/<slug>` — `feature/`, `bugfix/`, `hotfix/`, `chore/`, `refactor/`,
or `docs/`. `/ai-engineering:new-task` creates the branch (`git fetch
origin` + `git checkout -b <type>/<slug> origin/master`) as part of
scaffolding the task file, and records it in the task's `Branch:` field.
Nothing is ever committed directly to master. See `rules/git-workflow.md`.

## Example

```
> /ai-engineering:investigate the /export endpoint times out on large accounts

  Phase 1-2 output: traces the endpoint through 3 layers, finds it loads
  the full result set into memory before streaming, confirms (verified,
  via the query) there's no pagination — flags the actual row-count ceiling
  as unknown pending a query against production-like data.

> /ai-engineering:plan-change stream the export instead of loading it fully

  Plan: switch to a cursor-based DB read + chunked response writer, files
  touched, no schema change, backward-compatible response format, risk:
  memory-bound clients downstream — flagged for the user, not silently
  assumed away. Validated against the existing service-layer pattern.
  No code written yet — plan is presented for approval.
```

## Repo layout

```
CLAUDE.md                   entry point Claude Code loads automatically
README.md                   this file
VERSION
install.sh / install.ps1    project native assets into a host project
.claude/
  agents/software-engineer.md, laravel-engineer.md
  skills/{software-change,project-build,project-bootstrap,task-management,
          laravel-api,database-optimization,laravel-testing}/SKILL.md
  commands/ai-engineering/{investigate,plan-change,requirements,away,
                           new-task,close-task}.md
  hooks/away-stop.sh, away-stop.ps1   Stop hook for away mode
rules/                       architecture, coding-standards, security,
                              task-management, git-workflow, measurement,
                              logging-and-monitoring, integrations,
                              documentation, autonomous-mode
                              laravel, database, testing, devops
workflows/software-change.md the 8-phase process for changing code
workflows/project-build.md   building an application from a brief
prompts/project-bootstrap.md raw prompt the project-bootstrap skill runs
prompts/project-build.md     fill-in kickoff prompt for a brief-driven build
prompts/autonomous-mode.md   paste-in prompt for away mode
templates/                   requirements checklist, implementation report
settings/away-mode.json      permissions + Stop hook to merge for away mode
tasks/templates/task.md      task file template
tasks/{Pending,Done}/        this repo's own task instances (self-hosted use)
```

## Design notes

- **Layered, not monolithic.** The generic core (`software-engineer` +
  generic `rules/`) stays stack-agnostic and reusable anywhere; the
  Laravel/PHP specialization (`laravel-engineer` + `laravel-api` /
  `database-optimization` / `laravel-testing` + the Laravel `rules/`)
  builds on top of it rather than forking it. Adding another stack
  specialization later means adding a new agent + rules + skills, not
  rewriting the core.
- **Native, not documentation-only.** Agents/skills/commands are real
  Claude Code assets that get triggered and executed, not markdown that
  only shapes context if someone happens to read it.
- **No duplication.** Rules live once in `rules/`; every agent, skill, and
  command references them via `@` imports.
- **Copy by default, not symlink.** Plain Windows checkouts often can't
  create symlinks without elevated privileges or dev mode — copying is the
  default that works everywhere; symlinking is opt-in for setups that
  support it.
- **Task state stays in the host project.** `.claude/tasks/{Pending,Done}/`
  is created in whatever project is being worked on, never inside this
  submodule — the submodule is shared, versioned content and shouldn't
  accumulate another project's task history.
