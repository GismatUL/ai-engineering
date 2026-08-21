#!/usr/bin/env bash
# Install this repo's Claude Code native assets (.claude/agents, .claude/skills,
# .claude/commands) into a host project after adding it as a git submodule
# (or a plain clone — see --local below).
#
# Usage (run from the host project root):
#   ./ai-engineering/install.sh              # copy (default, works everywhere)
#   ./ai-engineering/install.sh --symlink    # symlink instead (POSIX / Windows dev mode)
#   ./ai-engineering/install.sh --local      # keep every trace out of the host repo's
#                                             # git history (see below)
#
# --local writes the rules imports to CLAUDE.local.md instead of CLAUDE.md
# (Claude Code auto-loads CLAUDE.local.md; it's meant to be gitignored) and
# appends every path this script installs to .git/info/exclude — a per-clone
# ignore file that never gets committed. This does NOT retroactively hide a
# real `git submodule add` (that command stages .gitmodules and a gitlink
# the moment it runs) — for a fully invisible setup, clone this repo as a
# plain directory instead of registering it as a submodule.
set -euo pipefail

MODE="copy"
LOCAL_MODE="false"
for arg in "$@"; do
  case "$arg" in
    --symlink) MODE="symlink" ;;
    --local) LOCAL_MODE="true" ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

SUBMODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST_ROOT="$(pwd)"

if [[ "$SUBMODULE_DIR" == "$HOST_ROOT" ]]; then
  echo "Refusing to install into the ai-engineering repo itself (it self-hosts .claude/ already)." >&2
  echo "Run this script from the host project's root instead." >&2
  exit 1
fi

if command -v realpath >/dev/null 2>&1; then
  REL_SUBMODULE="$(realpath --relative-to="$HOST_ROOT" "$SUBMODULE_DIR")"
else
  REL_SUBMODULE="$SUBMODULE_DIR"
fi

echo "Installing ai-engineering assets ($MODE) from $SUBMODULE_DIR"
echo "                                     into $HOST_ROOT/.claude"

INSTALLED_REL_PATHS=()

install_tree() {
  local src_root="$1"
  local dest_root="$2"
  [[ -d "$src_root" ]] || return 0
  while IFS= read -r -d '' file; do
    rel="${file#"$src_root"/}"
    dest="$dest_root/$rel"
    mkdir -p "$(dirname "$dest")"
    if [[ "$MODE" == "symlink" ]]; then
      ln -sf "$file" "$dest"
    else
      cp -f "$file" "$dest"
    fi
    echo "  $rel"
    INSTALLED_REL_PATHS+=("${dest#"$HOST_ROOT"/}")
  done < <(find "$src_root" -type f -print0)
}

install_tree "$SUBMODULE_DIR/.claude/agents" "$HOST_ROOT/.claude/agents"
install_tree "$SUBMODULE_DIR/.claude/skills" "$HOST_ROOT/.claude/skills"
install_tree "$SUBMODULE_DIR/.claude/commands" "$HOST_ROOT/.claude/commands"

mkdir -p "$HOST_ROOT/.claude"
MANIFEST_REL=".claude/.ai-engineering-installed"
{
  echo "ai-engineering install manifest"
  echo "source: $SUBMODULE_DIR"
  echo "mode: $MODE"
  echo "local: $LOCAL_MODE"
  echo "installed: $(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || echo unknown)"
} > "$HOST_ROOT/$MANIFEST_REL"

if [[ "$LOCAL_MODE" == "true" ]]; then
  CLAUDE_MD="$HOST_ROOT/CLAUDE.local.md"
  MARKER="## AI Engineering (submodule, local-only)"
else
  CLAUDE_MD="$HOST_ROOT/CLAUDE.md"
  MARKER="## AI Engineering (submodule)"
fi
[[ -f "$CLAUDE_MD" ]] || : > "$CLAUDE_MD"

if grep -qF "$MARKER" "$CLAUDE_MD"; then
  echo "$(basename "$CLAUDE_MD") already references ai-engineering rules, skipping."
else
  {
    echo ""
    echo "$MARKER"
    echo ""
    echo "@$REL_SUBMODULE/rules/architecture.md"
    echo "@$REL_SUBMODULE/rules/coding-standards.md"
    echo "@$REL_SUBMODULE/rules/security.md"
    echo "@$REL_SUBMODULE/rules/task-management.md"
  } >> "$CLAUDE_MD"
  echo "Appended ai-engineering rules imports to $CLAUDE_MD"
fi

if [[ "$LOCAL_MODE" == "true" ]]; then
  if [[ -d "$HOST_ROOT/.git" ]]; then
    EXCLUDE_FILE="$HOST_ROOT/.git/info/exclude"
    mkdir -p "$(dirname "$EXCLUDE_FILE")"
    [[ -f "$EXCLUDE_FILE" ]] || : > "$EXCLUDE_FILE"
    BEGIN_MARK="# BEGIN ai-engineering (local install, do not commit)"
    END_MARK="# END ai-engineering (local install)"
    awk -v b="$BEGIN_MARK" -v e="$END_MARK" \
      'BEGIN{skip=0} $0==b{skip=1; next} $0==e{skip=0; next} !skip{print}' \
      "$EXCLUDE_FILE" > "$EXCLUDE_FILE.tmp"
    mv "$EXCLUDE_FILE.tmp" "$EXCLUDE_FILE"
    {
      echo "$BEGIN_MARK"
      echo "/CLAUDE.local.md"
      echo "/$MANIFEST_REL"
      for p in "${INSTALLED_REL_PATHS[@]}"; do
        echo "/$p"
      done
      # Only takes effect if this is a plain clone, not a real submodule
      # (a registered submodule's gitlink is tracked, not untracked, so
      # ignore rules don't apply to it).
      echo "/$REL_SUBMODULE/"
      echo "$END_MARK"
    } >> "$EXCLUDE_FILE"
    echo "Added installed paths to $EXCLUDE_FILE (never committed, local to this clone)."
  else
    echo "Warning: $HOST_ROOT/.git not found — skipped writing .git/info/exclude. Add the installed paths to your ignore rules manually." >&2
  fi
  echo "Note: if you added this as a real submodule (git submodule add), .gitmodules and the" \
       "gitlink are already staged — --local can't undo that. Use a plain clone for a fully" \
       "invisible install."
fi

echo "Done. Re-running this script will refresh the installed files with the submodule's current version."
