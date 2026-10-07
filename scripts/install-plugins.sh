#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest_path="$repo_root/plugins/claude-plugins.txt"
dry_run=0

usage() {
  cat <<'USAGE'
Usage: install-plugins.sh [--dry-run]

Installs the Claude Code plugins listed in plugins/claude-plugins.txt at user
scope. Reaches GitHub to clone each marketplace; already installed plugins are
skipped. Kept separate from install.sh because that script makes no network calls.
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

if ! command -v claude >/dev/null 2>&1; then
  printf 'missing: command not found: claude\n' >&2
  exit 1
fi

installed_plugins="$(claude plugin list --json)"
known_marketplaces="$(claude plugin marketplace list --json)"

while read -r marketplace_repo plugin_id || [ -n "$marketplace_repo" ]; do
  case "$marketplace_repo" in ''|'#'*) continue ;; esac

  if printf '%s' "$known_marketplaces" | grep -Fq "\"repo\": \"$marketplace_repo\""; then
    printf 'already added: marketplace %s\n' "$marketplace_repo"
  elif [ "$dry_run" -eq 1 ]; then
    printf 'would add marketplace: %s\n' "$marketplace_repo"
  else
    claude plugin marketplace add "$marketplace_repo"
  fi

  if printf '%s' "$installed_plugins" | grep -Fq "\"id\": \"$plugin_id\""; then
    printf 'already installed: %s\n' "$plugin_id"
  elif [ "$dry_run" -eq 1 ]; then
    printf 'would install plugin: %s\n' "$plugin_id"
  else
    claude plugin install "$plugin_id" --scope user
  fi
done < "$manifest_path"
