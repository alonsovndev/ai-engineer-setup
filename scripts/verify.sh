#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failed=0
warnings=0
check_claude=0
check_opencode=0
check_copilot=0
check_antigravity=0

usage() {
  cat <<'USAGE'
Usage: verify.sh [--harness claude|opencode|copilot|antigravity]... [--all]

Validates the portable AI-agent setup for this clone.
When no harness is specified, all supported harnesses are checked.
USAGE
}

select_all_harnesses() {
  check_claude=1
  check_opencode=1
  check_copilot=1
  check_antigravity=1
}

if [ "$#" -eq 0 ]; then
  select_all_harnesses
fi

while [ "$#" -gt 0 ]; do
  case "$1" in
    --harness)
      case "${2:-}" in
        claude) check_claude=1 ;;
        opencode) check_opencode=1 ;;
        copilot) check_copilot=1 ;;
        antigravity) check_antigravity=1 ;;
        *) printf 'Unknown harness: %s\n' "${2:-}" >&2; usage >&2; exit 2 ;;
      esac
      shift 2
      ;;
    --all)
      select_all_harnesses
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

check_command() {
  local command_name="$1"
  if command -v "$command_name" >/dev/null 2>&1; then
    printf 'ok: command available: %s (%s)\n' "$command_name" "$(command -v "$command_name")"
  else
    printf 'missing: command not found: %s\n' "$command_name"
    failed=1
  fi
}

check_link() {
  local target_path="$1"
  local expected_path="$2"

  if [ ! -L "$target_path" ]; then
    printf 'missing link: %s\n' "$target_path"
    failed=1
    return 0
  fi

  local current_target
  current_target="$(readlink "$target_path")"
  if [ "$current_target" = "$expected_path" ]; then
    printf 'ok: %s -> %s\n' "$target_path" "$expected_path"
  else
    printf 'wrong link: %s -> %s (expected %s)\n' "$target_path" "$current_target" "$expected_path"
    failed=1
  fi
}

check_file_contains() {
  local target_path="$1"
  local expected_text="$2"
  local label="$3"

  if [ ! -f "$target_path" ]; then
    printf 'missing file: %s\n' "$target_path"
    failed=1
    return 0
  fi

  if grep -Fq "$expected_text" "$target_path"; then
    printf 'ok: %s: %s\n' "$label" "$target_path"
  else
    printf 'missing expected content: %s (%s)\n' "$target_path" "$label"
    failed=1
  fi
}

check_required_path() {
  local path_to_check="$1"
  if [ -e "$path_to_check" ]; then
    printf 'ok: exists: %s\n' "$path_to_check"
  else
    printf 'missing: %s\n' "$path_to_check"
    failed=1
  fi
}

printf 'Checking local commands only. No model/provider calls are made.\n\n'

[ "$check_claude" -eq 1 ] && check_command claude
[ "$check_opencode" -eq 1 ] && check_command opencode
[ "$check_copilot" -eq 1 ] && check_command copilot
[ "$check_antigravity" -eq 1 ] && check_command agy

printf '\nChecking required repository paths.\n'
check_required_path "$repo_root/instructions/AGENTS.md"
check_required_path "$repo_root/instructions/stacks/python-fastapi-ddd.md"
check_required_path "$repo_root/skills/tdd/SKILL.md"
check_required_path "$repo_root/skills/find-skills/SKILL.md"
check_required_path "$repo_root/skills/python-fastapi-ddd/SKILL.md"
check_required_path "$repo_root/skills/git-repo-flow/SKILL.md"
check_required_path "$repo_root/profiles/model-profiles.jsonc"

if [ "$check_claude" -eq 1 ]; then
  check_required_path "$repo_root/instructions/CLAUDE.md"
fi

if [ "$check_opencode" -eq 1 ]; then
  check_required_path "$repo_root/adapters/opencode/opencode.jsonc"
fi

printf '\nChecking agent and command parity across harnesses.\n'

# agents/claude and commands/claude are the canonical sets; every other harness
# must expose the same names in its own layout. Path templates below are
# repo-relative and use "@" as the name placeholder, so an "@" in the clone path
# cannot be substituted by mistake.
agent_names=()
while IFS= read -r canonical_name; do
  agent_names+=("$canonical_name")
done < <(find "$repo_root/agents/claude" -maxdepth 1 -type f -name '*.md' -exec basename {} .md \; | sort)

command_names=()
while IFS= read -r canonical_name; do
  command_names+=("$canonical_name")
done < <(find "$repo_root/commands/claude" -maxdepth 1 -type f -name '*.md' -exec basename {} .md \; | sort)

name_in_list() {
  local needle="$1"
  shift
  local item
  for item in "$@"; do
    if [ "$item" = "$needle" ]; then
      return 0
    fi
  done
  return 1
}

check_parity() {
  local label="$1"
  local relative_template="$2"
  shift 2

  local total=0
  local missing=0
  local name
  local expected_path

  for name in "$@"; do
    total=$((total + 1))
    expected_path="$repo_root/${relative_template//@/$name}"
    if [ ! -e "$expected_path" ]; then
      printf 'missing: %s (%s)\n' "$expected_path" "$label"
      missing=$((missing + 1))
      failed=1
    fi
  done

  if [ "$missing" -eq 0 ]; then
    printf 'ok: %s: %d/%d present\n' "$label" "$total" "$total"
  fi
}

# Fails on files a harness has but the canonical set does not, so a one-off
# addition to a single harness cannot pass verification.
check_extras() {
  local label="$1"
  local relative_dir="$2"
  local file_pattern="$3"
  local strip_suffix="$4"
  shift 4

  local search_dir="$repo_root/$relative_dir"
  if [ ! -d "$search_dir" ]; then
    printf 'missing directory: %s (%s)\n' "$search_dir" "$label"
    failed=1
    return 0
  fi

  local extras=0
  local found_path
  local found_name

  while IFS= read -r found_path; do
    found_name="$(basename "$found_path" "$strip_suffix")"
    if ! name_in_list "$found_name" "$@"; then
      printf 'unexpected: %s has no counterpart in the canonical set (%s)\n' "$found_path" "$label"
      extras=$((extras + 1))
      failed=1
    fi
  done < <(find "$search_dir" -maxdepth 1 -type f -name "$file_pattern" | sort)

  if [ "$extras" -eq 0 ]; then
    printf 'ok: %s: no unexpected entries\n' "$label"
  fi
}

# Antigravity uses <name>/agent.md, so both stray directories and stray loose
# files under agents/antigravity/ have to be caught by name.
check_antigravity_extras() {
  local search_dir="$repo_root/agents/antigravity"
  if [ ! -d "$search_dir" ]; then
    printf 'missing directory: %s (antigravity agents)\n' "$search_dir"
    failed=1
    return 0
  fi

  local extras=0
  local entry_path
  local entry_name

  while IFS= read -r entry_path; do
    entry_name="$(basename "$entry_path")"
    if ! name_in_list "$entry_name" "$@"; then
      printf 'unexpected: %s has no counterpart in the canonical set (antigravity agents)\n' "$entry_path"
      extras=$((extras + 1))
      failed=1
    fi
  done < <(find "$search_dir" -mindepth 1 -maxdepth 1 | sort)

  if [ "$extras" -eq 0 ]; then
    printf 'ok: antigravity agents: no unexpected entries\n'
  fi
}

# Returns 1 when the file exists but carries no usable frontmatter description.
check_frontmatter_description() {
  local path_to_check="$1"

  # A missing file is already reported by check_parity.
  [ -f "$path_to_check" ] || return 0

  if [ "$(head -n 1 "$path_to_check")" != "---" ]; then
    printf 'missing frontmatter: %s\n' "$path_to_check"
    failed=1
    return 1
  fi

  # Stops at the closing delimiter, so body text cannot satisfy the check.
  if awk 'NR==1{next} /^---$/{exit} {print}' "$path_to_check" \
    | grep -qE '^description:[[:space:]]*[^[:space:]]'; then
    return 0
  fi

  printf 'missing frontmatter description: %s\n' "$path_to_check"
  failed=1
  return 1
}

check_descriptions() {
  local label="$1"
  local relative_template="$2"
  shift 2

  local name
  local bad=0
  for name in "$@"; do
    if ! check_frontmatter_description "$repo_root/${relative_template//@/$name}"; then
      bad=$((bad + 1))
    fi
  done

  if [ "$bad" -eq 0 ]; then
    printf 'ok: %s: all present\n' "$label"
  fi
}

# Keeps per-command metadata (Claude argument hints, opencode usage lines) from
# drifting as new commands are added.
check_metadata() {
  local label="$1"
  local relative_template="$2"
  local required_pattern="$3"
  shift 3

  local name
  local path_to_check
  local missing=0

  for name in "$@"; do
    path_to_check="$repo_root/${relative_template//@/$name}"
    [ -f "$path_to_check" ] || continue
    if ! grep -qE "$required_pattern" "$path_to_check"; then
      printf 'missing %s: %s\n' "$label" "$path_to_check"
      missing=$((missing + 1))
      failed=1
    fi
  done

  if [ "$missing" -eq 0 ]; then
    printf 'ok: %s: all present\n' "$label"
  fi
}

if [ "${#agent_names[@]}" -eq 0 ]; then
  printf 'missing: no agent definitions found in agents/claude\n'
  failed=1
fi

if [ "${#command_names[@]}" -eq 0 ]; then
  printf 'missing: no command definitions found in commands/claude\n'
  failed=1
fi

if [ "${#agent_names[@]}" -eq 0 ] || [ "${#command_names[@]}" -eq 0 ]; then
  printf 'skipped: parity checks need a non-empty canonical set\n'
else
  printf 'canonical set: %d agents, %d commands\n' "${#agent_names[@]}" "${#command_names[@]}"

  if [ "$check_claude" -eq 1 ]; then
    check_descriptions 'claude agent descriptions' 'agents/claude/@.md' "${agent_names[@]}"
    check_metadata 'claude command argument-hint' 'commands/claude/@.md' '^argument-hint:[[:space:]]*[^[:space:]]' "${command_names[@]}"
  fi

  if [ "$check_opencode" -eq 1 ]; then
    check_parity 'opencode agents' 'agents/opencode/@.md' "${agent_names[@]}"
    check_extras 'opencode agents' 'agents/opencode' '*.md' '.md' "${agent_names[@]}"
    check_descriptions 'opencode agent descriptions' 'agents/opencode/@.md' "${agent_names[@]}"
    check_parity 'opencode commands' 'commands/opencode/@.md' "${command_names[@]}"
    check_extras 'opencode commands' 'commands/opencode' '*.md' '.md' "${command_names[@]}"
    check_metadata 'opencode command usage line' 'commands/opencode/@.md' '^Usage:[[:space:]]*[^[:space:]]' "${command_names[@]}"
  fi

  if [ "$check_copilot" -eq 1 ]; then
    check_parity 'copilot agents' 'agents/copilot/@.agent.md' "${agent_names[@]}"
    check_extras 'copilot agents' 'agents/copilot' '*.agent.md' '.agent.md' "${agent_names[@]}"
    check_descriptions 'copilot agent descriptions' 'agents/copilot/@.agent.md' "${agent_names[@]}"
    check_parity 'copilot prompts' 'commands/copilot-prompts/@.prompt.md' "${command_names[@]}"
    check_extras 'copilot prompts' 'commands/copilot-prompts' '*.prompt.md' '.prompt.md' "${command_names[@]}"

    # The registry in copilot-instructions.md is the routing contract Copilot
    # reads; an agent missing from it is invisible even though its file exists.
    registry_file="$repo_root/adapters/copilot/instructions/copilot-instructions.md"
    if [ ! -f "$registry_file" ]; then
      printf 'missing: %s\n' "$registry_file"
      failed=1
    else
      registry_section="$(awk '/^## Agent Registry/{inside=1; next} /^## /{inside=0} inside' "$registry_file")"
      registry_missing=0
      for agent_name in "${agent_names[@]}"; do
        # Only a numbered entry of its own counts as registration; a mention
        # inside another entry or in the routing notes must not satisfy this.
        if ! printf '%s\n' "$registry_section" | grep -qE "^[0-9]+\. \`${agent_name}\`"; then
          printf 'missing from Copilot Agent Registry: %s (%s)\n' "$agent_name" "$registry_file"
          registry_missing=$((registry_missing + 1))
          failed=1
        fi
      done
      if [ "$registry_missing" -eq 0 ]; then
        printf 'ok: copilot Agent Registry lists all %d agents\n' "${#agent_names[@]}"
      fi
    fi
  fi

  if [ "$check_antigravity" -eq 1 ]; then
    check_parity 'antigravity agents' 'agents/antigravity/@/agent.md' "${agent_names[@]}"
    check_antigravity_extras "${agent_names[@]}"
    check_descriptions 'antigravity agent descriptions' 'agents/antigravity/@/agent.md' "${agent_names[@]}"
  fi
fi

printf '\nChecking symlinks.\n'
check_link "$HOME/.agents/skills" "$repo_root/skills"

if [ "$check_claude" -eq 1 ]; then
  check_link "$HOME/.claude/AGENTS.md" "$repo_root/instructions/AGENTS.md"
  check_link "$HOME/.claude/CLAUDE.md" "$repo_root/instructions/CLAUDE.md"
  check_link "$HOME/.claude/skills" "$repo_root/skills"
  check_link "$HOME/.claude/agents" "$repo_root/agents/claude"
  check_link "$HOME/.claude/commands" "$repo_root/commands/claude"
fi

if [ "$check_opencode" -eq 1 ]; then
  check_file_contains "$HOME/.config/opencode/opencode.jsonc" 'Generated by ai-agent-setup/scripts/install.sh' 'opencode config generated by install.sh'
  check_file_contains "$HOME/.config/opencode/opencode.jsonc" "$repo_root/instructions/AGENTS.md" 'opencode instructions path'
  check_file_contains "$HOME/.config/opencode/opencode.jsonc" "$repo_root/skills" 'opencode skills path'
  check_link "$HOME/.config/opencode/agent" "$repo_root/agents/opencode"
  check_link "$HOME/.config/opencode/command" "$repo_root/commands/opencode"
fi

if [ "$check_copilot" -eq 1 ]; then
  check_link "$HOME/.copilot/skills" "$repo_root/skills"
  check_link "$HOME/.copilot/agents" "$repo_root/agents/copilot"
  check_link "$HOME/.copilot/.github/instructions" "$repo_root/adapters/copilot/instructions"
  check_link "$HOME/.copilot/.github/prompts" "$repo_root/commands/copilot-prompts"
fi

if [ "$check_antigravity" -eq 1 ]; then
  check_link "$HOME/.gemini/config/AGENTS.md" "$repo_root/instructions/AGENTS.md"
  check_link "$HOME/.gemini/config/skills" "$repo_root/skills"
  check_link "$HOME/.gemini/config/agents" "$repo_root/agents/antigravity"
fi

printf '\nChecking model profile consistency.\n'
if command -v python3 >/dev/null 2>&1; then
  python3 -c "
import json, sys, re

# Parse profiles JSON (strip comments)
with open('$repo_root/profiles/model-profiles.jsonc') as f:
    content = ''.join(l for l in f if not l.strip().startswith('//'))
profiles = json.loads(content)

# Parse run-agent.sh model mappings
with open('$repo_root/scripts/run-agent.sh') as f:
    script = f.read()

script_models = {}
for profile in ['deep', 'balanced', 'fast']:
    block = re.search(rf'{profile}\)(.*?)\n\s*;;', script, re.DOTALL)
    if block:
        for harness_var, harness_key in [
            ('claude_model', 'claude'),
            ('copilot_model', 'copilot'),
            ('opencode_model', 'opencode'),
            ('antigravity_model', 'antigravity'),
        ]:
            m = re.search(rf'{harness_var}=\"([^\"]+)\"', block.group(1))
            if m:
                script_models[f'{profile}/{harness_key}'] = m.group(1)

# Compare
ok = True
for pname, p in profiles.get('profiles', {}).items():
    for h in ['claude', 'copilot', 'opencode', 'antigravity']:
        if h in p:
            key = f'{pname}/{h}'
            profile_model = p[h].get('model', '')
            script_model = script_models.get(key, 'NOT_FOUND')
            if profile_model == script_model:
                print(f'ok: {key} = {profile_model}')
            else:
                print(f'mismatch: {key} profiles.jsonc={profile_model} run-agent.sh={script_model}')
                ok = False

if ok:
    print('All model profiles match run-agent.sh mappings.')
else:
    print('WARN: Model profile drift detected. Update profiles/model-profiles.jsonc or scripts/run-agent.sh.')
    sys.exit(1)
" || warnings=1
else
  printf 'warn: python3 not available for model cross-check\n'
  warnings=1
fi

printf '\nChecking git aliases.\n'
for alias_name in sync resync feature; do
  if git config --global --get "alias.${alias_name}" >/dev/null 2>&1; then
    printf 'ok: git alias available: %s\n' "$alias_name"
  else
    printf 'warn: git alias not found: %s\n' "$alias_name"
    warnings=1
  fi
done

if [ "$failed" -eq 0 ]; then
  if [ "$warnings" -eq 0 ]; then
    printf '\nVerification passed.\n'
  else
    printf '\nVerification passed with warnings.\n'
  fi
else
  printf '\nVerification found issues.\n'
fi

exit "$failed"
