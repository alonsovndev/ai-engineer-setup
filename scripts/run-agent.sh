#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: run-agent.sh --harness claude|opencode|copilot|antigravity|codex [--profile deep|balanced|fast] [--mode work|plan|auto] [--agent name] [--] [prompt...]

Starts the selected AI harness with a consistent profile vocabulary.
This script does not bypass permissions by default.
USAGE
}

harness=""
profile="balanced"
mode="work"
agent=""
arguments=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --harness)
      harness="${2:-}"
      shift 2
      ;;
    --profile)
      profile="${2:-}"
      shift 2
      ;;
    --mode)
      mode="${2:-}"
      shift 2
      ;;
    --agent)
      agent="${2:-}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    --)
      shift
      arguments+=("$@")
      break
      ;;
    *)
      arguments+=("$1")
      shift
      ;;
  esac
done

if [ -z "$harness" ]; then
  usage
  exit 2
fi

case "$profile" in
  deep)
    claude_model="opus"
    claude_effort="high"
    copilot_model="claude-opus-4.7"
    copilot_effort="high"
    opencode_model="anthropic/claude-opus-5"
    antigravity_model="gemini-3.1-pro-high"
    codex_effort="high"
    ;;
  balanced)
    claude_model="sonnet"
    claude_effort="medium"
    copilot_model="gpt-5.4"
    copilot_effort="medium"
    opencode_model="anthropic/claude-sonnet-5"
    antigravity_model="gemini-3.8-flash-medium"
    codex_effort="medium"
    ;;
  fast)
    claude_model="fable"
    claude_effort="low"
    copilot_model="gpt-5.4-mini"
    copilot_effort="low"
    opencode_model="anthropic/claude-haiku-4-5"
    antigravity_model="gemini-3.8-flash-low"
    codex_effort="low"
    ;;
  *)
    printf 'Unknown profile: %s\n' "$profile" >&2
    exit 2
    ;;
esac

case "$harness" in
  claude)
    command_args=(--model "$claude_model" --effort "$claude_effort")
    [ -n "$agent" ] && command_args+=(--agent "$agent")
    case "$mode" in
      work) ;;
      plan) command_args+=(--permission-mode plan) ;;
      auto) command_args+=(--permission-mode auto) ;;
      *) printf 'Unknown mode: %s\n' "$mode" >&2; exit 2 ;;
    esac
    exec claude "${command_args[@]}" ${arguments[@]+"${arguments[@]}"}
    ;;
  opencode)
    command_args=(--model "$opencode_model")
    [ -n "$agent" ] && command_args+=(--agent "$agent")
    case "$mode" in
      work) ;;
      plan) command_args+=(--agent plan) ;;
      auto) command_args+=(--auto) ;;
      *) printf 'Unknown mode: %s\n' "$mode" >&2; exit 2 ;;
    esac
    exec opencode "${command_args[@]}" ${arguments[@]+"${arguments[@]}"}
    ;;
  copilot)
    command_args=(--model "$copilot_model" --effort "$copilot_effort")
    [ -n "$agent" ] && command_args+=(--agent "$agent")
    case "$mode" in
      work) ;;
      plan) command_args+=(--plan) ;;
      auto) command_args+=(--mode autopilot) ;;
      *) printf 'Unknown mode: %s\n' "$mode" >&2; exit 2 ;;
    esac
    exec copilot "${command_args[@]}" ${arguments[@]+"${arguments[@]}"}
    ;;
  antigravity)
    command_args=(--model "$antigravity_model")
    [ -n "$agent" ] && command_args+=(--agent "$agent")
    case "$mode" in
      work) ;;
      plan) command_args+=(--mode=plan) ;;
      auto) command_args+=(--mode=accept-edits) ;;
      *) printf 'Unknown mode: %s\n' "$mode" >&2; exit 2 ;;
    esac
    exec agy "${command_args[@]}" ${arguments[@]+"${arguments[@]}"}
    ;;
  codex)
    command_args=(-c "model_reasoning_effort=\"$codex_effort\"")
    codex_mode_prefix=""
    case "$mode" in
      work)
        command_args+=(--sandbox workspace-write --ask-for-approval on-request)
        ;;
      plan)
        command_args+=(--sandbox read-only --ask-for-approval on-request)
        codex_mode_prefix="Plan the requested work without making changes. State assumptions and a concrete implementation plan. Task:"
        ;;
      auto)
        command_args+=(--approve-for-me)
        ;;
      *) printf 'Unknown mode: %s\n' "$mode" >&2; exit 2 ;;
    esac
    codex_prompt="$codex_mode_prefix"
    if [ -n "$agent" ]; then
      [ -n "$codex_prompt" ] && codex_prompt+=" "
      codex_prompt+="Ask the Codex custom subagent '$agent' to handle this task."
    fi
    for argument in ${arguments[@]+"${arguments[@]}"}; do
      if [ -n "$codex_prompt" ]; then
        codex_prompt+=" "
      fi
      codex_prompt+="$argument"
    done
    if [ -n "$codex_prompt" ]; then
      exec codex "${command_args[@]}" "$codex_prompt"
    fi
    exec codex "${command_args[@]}"
    ;;
  *)
    printf 'Unknown harness: %s\n' "$harness" >&2
    exit 2
    ;;
esac
