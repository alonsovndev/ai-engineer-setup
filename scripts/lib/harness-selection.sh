#!/usr/bin/env bash

supported_harnesses='claude codex opencode copilot antigravity'
selected_harnesses=''
all_harnesses=0
dry_run=0

harness_selected() {
  case " $selected_harnesses " in
    *" $1 "*) return 0 ;;
    *) return 1 ;;
  esac
}

select_harness() {
  local supported_harness
  for supported_harness in $supported_harnesses; do
    if [ "$1" = "$supported_harness" ]; then
      if ! harness_selected "$1"; then
        selected_harnesses="${selected_harnesses:+$selected_harnesses }$1"
      fi
      return 0
    fi
  done
  printf 'Unknown harness: %s\n' "$1" >&2
  return 2
}

select_all_harnesses() {
  selected_harnesses="$supported_harnesses"
  all_harnesses=1
}

prompt_harness_selection() {
  local menu_input menu_choice invalid_selection
  while :; do
    cat <<'MENU'

Select tools:
  1) Claude Code
  2) Codex
  3) OpenCode
  4) GitHub Copilot
  5) Antigravity
  6) All supported tools
  0) Cancel
MENU
    printf 'Choose one or more numbers separated by spaces: '
    if ! IFS= read -r menu_input; then
      printf '\nSelection closed; no changes made.\n'
      exit 0
    fi

    # Limit input before word splitting so shell globs cannot expand menu choices.
    case "$menu_input" in
      *[!0-6$' \t']*) printf 'Invalid selection. Choose 1-6, or 0 to cancel.\n' >&2; continue ;;
    esac

    selected_harnesses=''
    all_harnesses=0
    invalid_selection=0
    for menu_choice in $menu_input; do
      case "$menu_choice" in
        1) select_harness claude ;;
        2) select_harness codex ;;
        3) select_harness opencode ;;
        4) select_harness copilot ;;
        5) select_harness antigravity ;;
        6) select_all_harnesses ;;
        0) printf 'Cancelled; no changes made.\n'; exit 0 ;;
        *) invalid_selection=1 ;;
      esac
    done

    if [ "$invalid_selection" -eq 0 ] && [ -n "$selected_harnesses" ]; then
      return 0
    fi
    printf 'Invalid selection. Choose 1-6, or 0 to cancel.\n' >&2
  done
}

parse_harness_selection() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --harness)
        if [ "$#" -lt 2 ]; then
          printf 'Missing value for --harness.\n' >&2
          usage >&2
          exit 2
        fi
        if ! select_harness "$2"; then
          usage >&2
          exit 2
        fi
        shift 2
        ;;
      --all) select_all_harnesses; shift ;;
      --dry-run) dry_run=1; shift ;;
      --help|-h) usage; exit 0 ;;
      *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
    esac
  done

  if [ -z "$selected_harnesses" ]; then
    if [ -t 0 ] && [ -t 1 ]; then
      prompt_harness_selection
    else
      printf 'No tools selected. Use --harness NAME or --all for noninteractive runs.\n' >&2
      usage >&2
      exit 2
    fi
  fi

  printf 'Selected tools: %s\n' "$selected_harnesses"
  if [ "$dry_run" -eq 1 ]; then
    printf 'Dry run; no changes will be made.\n'
  fi
}
