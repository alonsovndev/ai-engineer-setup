#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
temporary_dir="$(mktemp -d "${TMPDIR:-/tmp}/run-agent-selftest.XXXXXX")"
trap 'rm -r "$temporary_dir"' EXIT

cat >"$temporary_dir/codex" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$@"
MOCK
chmod +x "$temporary_dir/codex"

cat >"$temporary_dir/agy" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$@"
MOCK
chmod +x "$temporary_dir/agy"

assert_contains() {
  local output="$1"
  local expected="$2"
  local description="$3"
  if printf '%s\n' "$output" | grep -Fqx -- "$expected"; then
    printf 'PASS  %s\n' "$description"
  else
    printf 'FAIL  %s (missing %s)\n' "$description" "$expected" >&2
    return 1
  fi
}

assert_not_contains() {
  local output="$1"
  local unexpected="$2"
  local description="$3"
  if printf '%s\n' "$output" | grep -Fqx -- "$unexpected"; then
    printf 'FAIL  %s (unexpected %s)\n' "$description" "$unexpected" >&2
    return 1
  fi
  printf 'PASS  %s\n' "$description"
}

output="$(PATH="$temporary_dir:$PATH" "$repo_root/scripts/run-agent.sh" --harness codex --profile deep --mode plan --agent code-review -- 'inspect the diff')"
assert_contains "$output" 'model_reasoning_effort="high"' 'deep profile sets high reasoning'
assert_contains "$output" 'read-only' 'plan mode uses read-only sandbox'
assert_contains "$output" 'Plan the requested work without making changes. State assumptions and a concrete implementation plan. Task: Ask the Codex custom subagent '\''code-review'\'' to handle this task. inspect the diff' 'plan mode forwards task and selected subagent'
assert_not_contains "$output" '-m' 'Codex uses its configured default model'

output="$(PATH="$temporary_dir:$PATH" "$repo_root/scripts/run-agent.sh" --harness codex --profile balanced --mode work -- 'small task')"
assert_contains "$output" 'model_reasoning_effort="medium"' 'balanced profile sets medium reasoning'
assert_contains "$output" 'workspace-write' 'work mode uses workspace-write sandbox'
assert_contains "$output" 'on-request' 'work mode requests approval when needed'
assert_contains "$output" 'small task' 'work mode forwards prompt'

output="$(PATH="$temporary_dir:$PATH" "$repo_root/scripts/run-agent.sh" --harness codex --profile fast --mode auto -- 'fix docs')"
assert_contains "$output" 'model_reasoning_effort="low"' 'fast profile sets low reasoning'
assert_contains "$output" '--approve-for-me' 'auto mode uses automatic approval review'
assert_contains "$output" 'fix docs' 'auto mode forwards prompt'

# Empty arguments must not trip set -u on bash 3.2 (macOS default bash).
output="$(PATH="$temporary_dir:$PATH" "$repo_root/scripts/run-agent.sh" --harness codex --profile balanced --mode work)"
assert_contains "$output" 'model_reasoning_effort="medium"' 'no-args launch sets reasoning effort'
assert_contains "$output" 'workspace-write' 'no-args launch uses workspace-write sandbox'

output="$(PATH="$temporary_dir:$PATH" "$repo_root/scripts/run-agent.sh" --harness antigravity --profile deep --mode plan --agent code-review -- 'inspect the diff')"
assert_contains "$output" 'gemini-3.1-pro-high' 'antigravity deep profile selects gemini-3.1-pro-high'
assert_contains "$output" '--mode=plan' 'antigravity plan mode uses --mode=plan'
assert_contains "$output" '--agent' 'antigravity forwards the selected agent'
assert_contains "$output" 'code-review' 'antigravity forwards the agent name'
assert_contains "$output" 'inspect the diff' 'antigravity plan mode forwards prompt'

output="$(PATH="$temporary_dir:$PATH" "$repo_root/scripts/run-agent.sh" --harness antigravity --profile fast --mode auto -- 'small task')"
assert_contains "$output" 'gemini-3.8-flash-low' 'antigravity fast profile selects gemini-3.8-flash-low'
assert_contains "$output" '--mode=accept-edits' 'antigravity auto mode uses --mode=accept-edits'
assert_contains "$output" 'small task' 'antigravity auto mode forwards prompt'

# Empty arguments must not trip set -u on bash 3.2 (macOS default bash).
output="$(PATH="$temporary_dir:$PATH" "$repo_root/scripts/run-agent.sh" --harness antigravity --profile balanced --mode work)"
assert_contains "$output" 'gemini-3.8-flash-medium' 'antigravity no-args launch selects the balanced model'
assert_not_contains "$output" '--agent' 'antigravity no-args launch omits --agent'

printf '\nLauncher self-test passed.\n'
