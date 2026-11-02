#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest_path="$repo_root/third-party/skills.txt"
dry_run=0

usage() {
  cat <<'USAGE'
Usage: install-skills.sh [--dry-run]

Installs the third-party skills listed in third-party/skills.txt with
`npx skills add -g -y` (skills.sh). Skills already present under skills/ and
entries whose source is TBD are skipped. Run ./scripts/install.sh first so the
global skills path points into this repository. Kept separate from install.sh
because that script makes no network calls.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)
      dry_run=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ "$dry_run" -eq 0 ] && ! command -v npx >/dev/null 2>&1; then
  printf 'missing: command not found: npx\n' >&2
  exit 1
fi

while read -r skill_dir skill_source || [ -n "$skill_dir" ]; do
  case "$skill_dir" in ''|'#'*) continue ;; esac

  if [ -f "$repo_root/skills/$skill_dir/SKILL.md" ]; then
    printf 'already installed: %s\n' "$skill_dir"
  elif [ -z "${skill_source:-}" ] || [ "$skill_source" = "TBD" ]; then
    printf 'skipped: %s has no known source yet (TBD)\n' "$skill_dir"
  elif [ "$dry_run" -eq 1 ]; then
    printf 'would install: %s from %s\n' "$skill_dir" "$skill_source"
  else
    npx skills add "$skill_source" -g -y < /dev/null
    if [ ! -f "$repo_root/skills/$skill_dir/SKILL.md" ]; then
      printf 'warn: %s did not land in skills/ (is ~/.agents/skills linked here? run ./scripts/install.sh)\n' "$skill_dir" >&2
    fi
  fi
done < "$manifest_path"
