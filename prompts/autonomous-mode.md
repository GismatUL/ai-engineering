# Autonomous Mode Prompt

Paste this when `/ai-engineering:away` isn't installed — a cloud session,
a headless `claude -p` run, or a project without this repo. The rules it
follows are `rules/autonomous-mode.md`; set up permissions and the Stop
hook first (`settings/away-mode.json`), or the run will still stop on
permission prompts.

---

I'm away from my laptop {{FOR_HOW_LONG — e.g. "for about 7 hours"}}.
Work autonomously until no unblocked task remains or that time is used up.
Follow `rules/autonomous-mode.md`.

{{OPTIONAL_PRIORITIES — e.g. "Do the checkout bug first, then the export task."}}

- Continue from the current state. Inspect the project, git status, and
  `.claude/tasks/Pending/` first; do not restart, discard work, or redo
  completed phases.
- Create `.claude/tasks/.away` now; delete it only after the final report.
- Don't ask me to confirm phases or say "continue" — pick the next
  highest-priority unblocked task and take it through implementation,
  testing, review, and documentation.
- Run tests and builds, fix failures, rerun. Never report a result you
  didn't observe.
- Commit locally on each task's own branch from `origin/master`. Never
  push, merge, touch master, run destructive commands, touch production,
  deploy, or expose secrets.
- If a decision is genuinely mine, write the question under the task's
  `## Blocked`, set `Status: Blocked`, and move on. Don't wait for me.
- Keep each task's `## Notes` up to date as you go.

At the end, write `.claude/tasks/away-report-<YYYY-MM-DD-HHMM>.md`: what
you completed and verified, what is blocked and why, what remains, and
the decisions you made.

Start by inspecting the current state, then start working. Do not give me
a plan to approve.
