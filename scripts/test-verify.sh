#!/usr/bin/env bash
set -euo pipefail

# Self-test for scripts/verify.sh.
#
# Every check in the parity guard is asserted twice: the clean tree must pass,
# and a deliberately broken tree must fail. Without this, a regression in the
# guard itself is invisible — it would keep printing "ok" while checking nothing.
#
# The repository is copied to a path containing both a space and an "@" because
# two real defects (word-split globbing, and "@" being substituted inside the
# clone path) only appeared under those conditions.
#
# Symlink and command checks are skipped: they assert machine state, not repo
# state, and would fail from a copy. Only the parity section is exercised, via
# --harness runs whose failures come exclusively from the mutation under test.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work_root="$(mktemp -d "${TMPDIR:-/tmp}/verify-selftest.XXXXXX")"
clone="$work_root/my repo @ work"
passed=0
failed=0

cleanup() {
  chmod -R u+w "$work_root" 2>/dev/null || true
  rm -rf "$work_root"
}
trap cleanup EXIT

mkdir -p "$clone"
if command -v rsync >/dev/null 2>&1; then
  rsync -a --exclude '.git' "$repo_root/" "$clone/"
else
  (cd "$repo_root" && find . -path ./.git -prune -o -print0 | cpio -0pdm --quiet "$clone")
fi

# Runs verify.sh in the clone and reports only whether the parity section
# produced a failure line, so unrelated machine-state checks cannot affect the
# verdict.
parity_failed() {
  local harness="$1"
  local output

  output="$("$clone/scripts/verify.sh" --harness "$harness" 2>&1 || true)"
  printf '%s\n' "$output" \
    | awk '/parity across harnesses/{inside=1; next} /^Checking symlinks/{inside=0} inside' \
    | grep -qvE '^ok:|^warn:|^canonical set:|^$'
}

# assert <expectation> <harness> <description>
#   expectation: "clean" = no parity failure, "fails" = at least one
assert() {
  local expectation="$1"
  local harness="$2"
  local description="$3"

  local observed="clean"
  if parity_failed "$harness"; then
    observed="fails"
  fi

  if [ "$observed" = "$expectation" ]; then
    printf '  PASS  %s\n' "$description"
    passed=$((passed + 1))
  else
    printf '  FAIL  %s (expected %s, observed %s)\n' "$description" "$expectation" "$observed"
    failed=$((failed + 1))
  fi
}

restore() {
  local relative_path="$1"
  rm -rf "$clone/$relative_path"
  if [ -e "$repo_root/$relative_path" ]; then
    mkdir -p "$(dirname "$clone/$relative_path")"
    cp -R "$repo_root/$relative_path" "$clone/$relative_path"
  fi
}

printf 'Self-testing the parity guard from: %s\n\n' "$clone"

printf 'Baseline\n'
for harness in claude opencode copilot antigravity codex; do
  assert clean "$harness" "clean tree passes ($harness)"
done

printf '\nBenign artifacts must not fail\n'
touch "$clone/agents/antigravity/.DS_Store"
assert clean antigravity 'a .DS_Store under agents/antigravity is ignored'
rm "$clone/agents/antigravity/.DS_Store"

printf '\nMissing counterparts\n'
mv "$clone/commands/opencode/commit.md" "$work_root/held.md"
assert fails opencode 'an opencode command with no Claude counterpart is caught'
mv "$work_root/held.md" "$clone/commands/opencode/commit.md"

mv "$clone/agents/antigravity/terraform" "$work_root/held-dir"
assert fails antigravity 'a missing antigravity agent directory is caught'
mv "$work_root/held-dir" "$clone/agents/antigravity/terraform"

mv "$clone/agents/codex/terraform.toml" "$work_root/held-codex-agent.toml"
assert fails codex 'a missing Codex custom agent is caught'
mv "$work_root/held-codex-agent.toml" "$clone/agents/codex/terraform.toml"

if command -v python3 >/dev/null 2>&1 && python3 -c 'import tomllib' >/dev/null 2>&1; then
  sed 's/^description = .*/description = [invalid/' "$repo_root/agents/codex/terraform.toml" > "$clone/agents/codex/terraform.toml"
  assert fails codex 'invalid Codex custom-agent TOML is caught'
  restore agents/codex/terraform.toml
else
  printf '  SKIP  invalid Codex custom-agent TOML is caught (needs Python 3.11+ tomllib; grep fallback cannot detect it)\n'
fi

mv "$clone/adapters/codex/skills/commit/SKILL.md" "$work_root/held-codex-skill.md"
assert fails codex 'a missing Codex workflow skill is caught'
mv "$work_root/held-codex-skill.md" "$clone/adapters/codex/skills/commit/SKILL.md"

printf '\nUnexpected extras\n'
cp "$clone/commands/copilot-prompts/commit.prompt.md" "$clone/commands/copilot-prompts/orphan.prompt.md"
assert fails copilot 'a Copilot-only prompt is caught'
rm "$clone/commands/copilot-prompts/orphan.prompt.md"

cp "$clone/agents/opencode/terraform.md" "$clone/agents/antigravity/orphan.md"
assert fails antigravity 'a stray loose file under agents/antigravity is caught'
rm "$clone/agents/antigravity/orphan.md"

mkdir -p "$clone/agents/antigravity/orphan-agent"
assert fails antigravity 'a stray directory without agent.md is caught'
rmdir "$clone/agents/antigravity/orphan-agent"

cp "$clone/agents/codex/terraform.toml" "$clone/agents/codex/orphan.toml"
assert fails codex 'a Codex-only custom agent is caught'
rm "$clone/agents/codex/orphan.toml"

mkdir -p "$clone/adapters/codex/skills/orphan"
printf '%s\n' '---' 'name: orphan' 'description: orphan workflow' '---' 'instructions' > "$clone/adapters/codex/skills/orphan/SKILL.md"
assert fails codex 'a Codex-only workflow skill is caught'
rm -r "$clone/adapters/codex/skills/orphan"

mkdir -p "$clone/skills/commit"
printf '%s\n' '---' 'name: commit' 'description: stray workflow' '---' 'instructions' > "$clone/skills/commit/SKILL.md"
assert fails codex 'a Codex workflow skill in the shared skills tree is caught'
rm -r "$clone/skills/commit"

printf '\nWrong file type\n'
mkdir -p "$clone/agents/opencode/orphan.md"
assert fails opencode 'a directory named like an agent file is caught'
rmdir "$clone/agents/opencode/orphan.md"

printf '\nFrontmatter\n'
printf -- '---\ndescription:\n---\n\nbody\n' > "$clone/agents/opencode/terraform.md"
assert fails opencode 'an empty description value is caught'

printf -- '---\n---\n\ndescription: this is body text\n' > "$clone/agents/opencode/terraform.md"
assert fails opencode 'a description below the frontmatter block is caught'

printf -- '---\ndescription: real\nnever closed\n' > "$clone/agents/opencode/terraform.md"
assert fails opencode 'an unterminated frontmatter block is caught'

printf -- '---\nname: terraform\ndescription: Infrastructure agent. Use for: modules and state.\nmode: subagent\n---\n\nbody\n' \
  > "$clone/agents/opencode/terraform.md"
assert fails opencode 'an unquoted description containing ": " is caught'

printf -- 'no frontmatter at all\n' > "$clone/agents/opencode/terraform.md"
assert fails opencode 'a file with no frontmatter is caught'
restore agents/opencode/terraform.md

printf '\nCommand metadata\n'
sed 's/^argument-hint:/x-hint:/' "$repo_root/commands/claude/commit.md" > "$clone/commands/claude/commit.md"
assert fails claude 'a Claude command missing argument-hint is caught'
restore commands/claude/commit.md

sed 's/^Usage:/Note:/' "$repo_root/commands/opencode/commit.md" > "$clone/commands/opencode/commit.md"
assert fails opencode 'an opencode command missing its Usage line is caught'
restore commands/opencode/commit.md

sed 's/^argument-hint:/x-hint:/' "$repo_root/commands/copilot-prompts/commit.prompt.md" > "$clone/commands/copilot-prompts/commit.prompt.md"
assert fails copilot 'a Copilot prompt missing argument-hint is caught'
restore commands/copilot-prompts/commit.prompt.md

printf '\nCopilot registry and budget\n'
python3 - "$clone" <<'PYTHON'
import sys
path = sys.argv[1] + '/adapters/copilot/instructions/copilot-instructions.md'
text = open(path).read()
open(path, 'w').write(text.replace('1. `react-ui` (`agents/react-ui.agent.md`)', '1. see `react-ui` in the notes below'))
PYTHON
assert fails copilot 'an agent named only inside another entry is not registered'
restore adapters/copilot/instructions/copilot-instructions.md

python3 - "$clone" <<'PYTHON'
import sys
path = sys.argv[1] + '/adapters/copilot/instructions/copilot-instructions.md'
text = open(path).read()
open(path, 'w').write(text.replace('11. `doc-tracker`', '11. `ghost-agent` (`agents/ghost-agent.agent.md`)\n    - Purpose: deleted agent.\n12. `doc-tracker`'))
PYTHON
assert fails copilot 'a registry entry for a deleted agent is caught'
restore adapters/copilot/instructions/copilot-instructions.md

python3 - "$clone" <<'PYTHON'
import sys
path = sys.argv[1] + '/adapters/copilot/instructions/PERFORMANCE-BUDGET.md'
text = open(path).read()
open(path, 'w').write(text.replace('| `terraform` | `standard` | 1800 | 1000 |\n', ''))
PYTHON
assert fails copilot 'an agent missing from the performance budget table is caught'
restore adapters/copilot/instructions/PERFORMANCE-BUDGET.md

printf '\nRestored baseline\n'
for harness in claude opencode copilot antigravity codex; do
  assert clean "$harness" "tree restored cleanly ($harness)"
done

printf '\n%d passed, %d failed\n' "$passed" "$failed"
[ "$failed" -eq 0 ]
