#!/usr/bin/env bash
# Claude Code Stop hook for away mode (rules/autonomous-mode.md).
# While .claude/tasks/.away exists and unblocked tasks remain in
# .claude/tasks/Pending/, it tells Claude to keep working instead of
# stopping. Does nothing outside away mode. Gives up after MAX_CONTINUES
# forced continues so a stuck session can still end.
set -u

cat > /dev/null

ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
MARKER="$ROOT/.claude/tasks/.away"
PENDING="$ROOT/.claude/tasks/Pending"
MAX_CONTINUES=30

[[ -f "$MARKER" ]] || exit 0

open_tasks=()
for f in "$PENDING"/*.md; do
  [[ -f "$f" ]] || continue
  grep -qiE '^[-* ]*Status:[[:space:]]*Blocked' "$f" && continue
  open_tasks+=("$(basename "$f")")
done

[[ ${#open_tasks[@]} -eq 0 ]] && exit 0

count="$(grep -oE '^continues=[0-9]+' "$MARKER" | cut -d= -f2)"
count="${count:-0}"
[[ "$count" -ge "$MAX_CONTINUES" ]] && exit 0

{ grep -v '^continues=' "$MARKER"; echo "continues=$((count + 1))"; } > "$MARKER.tmp"
mv "$MARKER.tmp" "$MARKER"

list="$(printf '%s, ' "${open_tasks[@]}")"
list="${list%, }"
reason="Away mode is active and unblocked tasks remain in .claude/tasks/Pending/: $list. Continue with the next one per rules/autonomous-mode.md, or record it as Status: Blocked with the reason. When none remain, write the away report and delete .claude/tasks/.away."
reason="${reason//\\/\\\\}"
reason="${reason//\"/\\\"}"

printf '{"decision":"block","reason":"%s"}\n' "$reason"
