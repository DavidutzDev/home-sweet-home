#!/usr/bin/env bash

SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
MODULES_DIR="${SCRIPT_DIR}/modules"

declare -A MODULE_STATE
declare -A MODULE_LOADED
declare -A MODULE_DEPS
declare -A MODULE_RESULT
declare -a REQUIRED_MODULES=()
declare -a APPLY_ORDER=()
declare -a RUN_ORDER=()

_prefix() {
  echo "${1//\//_}"
}

require() {
  REQUIRED_MODULES+=("$1")
}

_load_module_file() {
  local name="$1"
  [[ "${MODULE_LOADED[$name]:-0}" == "1" ]] && return 0

  local path="${MODULES_DIR}/${name}.sh"
  [[ -f "$path" ]] || _die "Failed to find module '$name' at '$path'"

  MODULE_REQUIRES=()
  source "$path"

  MODULE_DEPS[$name]="${MODULE_REQUIRES[*]:-}"
  MODULE_LOADED[$name]=1
  MODULE_STATE[$name]="UNRESOLVED"
}

_resolve() {
  local name="$1"
  shift
  local -a path=("$@" "$name")

  _load_module_file "$name"

  case "${MODULE_STATE[$name]}" in
  RESOLVED)
    return 0
    ;;
  RESOLVING)
    log_error "Warning, circular dependency detected:" >&2
    printf '  -> %s\n' "${path[@]}" >&2
    exit 1
    ;;
  esac

  MODULE_STATE[$name]="RESOLVING"

  local dep
  for dep in ${MODULE_DEPS[$name]}; do
    _resolve "$dep" "${path[@]}"
  done

  MODULE_STATE[$name]="RESOLVED"
  APPLY_ORDER+=("$name")
}

_run_module_action() {
  local mod="$1"
  local action="$2"
  local required="$3"
  local fn="$(_prefix "$mod")::${action}"
  RUN_ORDER+=("$mod")

  local err=""
  if declare -F "$fn" >/dev/null; then
    log_info ">>> [$mod] ${action}"
    if "$fn"; then
      MODULE_RESULT[$mod]="OK"
    else
      MODULE_RESULT[$mod]="FAIL"
      err="Module '$mod' failed during ${action}"
    fi
  elif [[ "$required" == "1" ]]; then
    MODULE_RESULT[$mod]="FAIL"
    err="Could not find function '$fn' in '$mod'"
  else
    MODULE_RESULT[$mod]="SKIP"
    log_info "    [$mod] no ${action} defined, skipping"
  fi

  if [[ -n "$err" ]]; then
    [[ "${STRICT:-false}" == true ]] && _die "$err"
    log_error "$err"
  fi
  return 0
}

apply_modules() {
  [[ ${#REQUIRED_MODULES[@]} -gt 0 ]] || _die "No modules required"
  RUN_ORDER=()
  MODULE_RESULT=()
  local mod
  for mod in "${REQUIRED_MODULES[@]}"; do
    _resolve "$mod"
  done
  log_info "--- Modules to apply ---"
  printf '  - %s\n' "${APPLY_ORDER[@]}"
  for mod in "${APPLY_ORDER[@]}"; do
    _run_module_action "$mod" "apply" 1
  done
  print_module_summary "apply"
}

rollback_modules() {
  [[ ${#REQUIRED_MODULES[@]} -gt 0 ]] || _die "No modules required"
  RUN_ORDER=()
  MODULE_RESULT=()
  local mod
  for mod in "${REQUIRED_MODULES[@]}"; do
    _resolve "$mod"
  done
  log_info "--- Modules to rollback ---"
  local i
  for ((i = ${#APPLY_ORDER[@]} - 1; i >= 0; i--)); do
    echo "  - ${APPLY_ORDER[i]}"
  done
  echo
  for ((i = ${#APPLY_ORDER[@]} - 1; i >= 0; i--)); do
    _run_module_action "${APPLY_ORDER[i]}" "rollback" 0
  done
  print_module_summary "rollback"
}

apply_one() {
  local target="$1"
  [[ -n "$target" ]] || _die "apply_one: module name required"
  APPLY_ORDER=()
  RUN_ORDER=()
  MODULE_RESULT=()
  _resolve "$target"
  log_info "--- Applying '$target' ---"
  printf '  - %s\n' "${APPLY_ORDER[@]}"
  echo
  local mod
  for mod in "${APPLY_ORDER[@]}"; do
    _run_module_action "$mod" "apply" 1
  done
  print_module_summary "apply"
}

rollback_one() {
  local target="$1"
  [[ -n "$target" ]] || _die "rollback_one: module name required"
  RUN_ORDER=()
  MODULE_RESULT=()
  _load_module_file "$target"
  log_info "--- Rolling back '$target' ---"
  echo
  _run_module_action "$target" "rollback" 1
  print_module_summary "rollback"
}

print_module_summary() {
  local action="$1"
  [[ ${#RUN_ORDER[@]} -gt 0 ]] || return 0
  echo
  log_info "--- ${action^} summary ---"
  local mod res ok=0 skip=0 fail=0
  for mod in "${RUN_ORDER[@]}"; do
    res="${MODULE_RESULT[$mod]:-?}"
    case "$res" in
    OK)
      log_success "     $mod"
      ok=$((ok + 1))
      ;;
    SKIP)
      log_info "  [skip] $mod"
      skip=$((skip + 1))
      ;;
    FAIL)
      log_error "  [FAIL] $mod"
      fail=$((fail + 1))
      ;;
    *) log_info "  [?]    $mod" ;;
    esac
  done
  echo
  log_info "Total: ${ok} ok, ${skip} skipped, ${fail} failed"
  [[ $fail -eq 0 ]]
}
