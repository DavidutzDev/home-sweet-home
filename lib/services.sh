_service_enabled() {
  if [[ "$1" == "user" ]]; then
    systemctl --user is-enabled "$2" &>/dev/null
  else
    systemctl is-enabled "$2" &>/dev/null
  fi
}
_service_active() {
  if [[ "$1" == "user" ]]; then
    systemctl --user is-active "$2" &>/dev/null
  else
    systemctl is-active "$2" &>/dev/null
  fi
}

_service_run() {
  local scope="$1"
  shift
  if [[ "$scope" == "user" ]]; then
    systemctl --user "$@"
  else
    sudo systemctl "$@"
  fi
}

_ensure_service() {
  local scope="$1" what="$2" unit="$3"
  local label
  [[ "$scope" == "user" ]] && label="user" || label="system"

  case "$what" in
  enable)
    if _service_enabled "$scope" "$unit"; then
      log_info "Service '$unit' ($label) is already enabled. Skipping."
      return 0
    fi
    log_info "Enabling service '$unit' ($label)..."
    if _service_run "$scope" enable "$unit"; then
      log_success "Service '$unit' ($label) successfully enabled."
    else
      log_error "Failed to enable service '$unit' ($label)."
      return 1
    fi
    ;;
  start)
    if _service_active "$scope" "$unit"; then
      log_info "Service '$unit' ($label) is already running. Skipping."
      return 0
    fi
    log_info "Starting service '$unit' ($label)..."
    if _service_run "$scope" start "$unit"; then
      log_success "Service '$unit' ($label) successfully started."
    else
      log_error "Failed to start service '$unit' ($label)."
      return 1
    fi
    ;;
  esac
}

_ensure_service_remove() {
  local scope="$1" what="$2" unit="$3"
  local label
  [[ "$scope" == "user" ]] && label="user" || label="system"

  case "$what" in
  disable)
    if ! _service_enabled "$scope" "$unit"; then
      log_info "Service '$unit' ($label) is not enabled. Skipping."
      return 0
    fi
    log_info "Disabling service '$unit' ($label)..."
    if _service_run "$scope" disable "$unit"; then
      log_success "Service '$unit' ($label) successfully disabled."
    else
      log_error "Failed to disable service '$unit' ($label)."
      return 1
    fi
    ;;
  stop)
    if ! _service_active "$scope" "$unit"; then
      log_info "Service '$unit' ($label) is not running. Skipping."
      return 0
    fi
    log_info "Stopping service '$unit' ($label)..."
    if _service_run "$scope" stop "$unit"; then
      log_success "Service '$unit' ($label) successfully stopped."
    else
      log_error "Failed to stop service '$unit' ($label)."
      return 1
    fi
    ;;
  esac
}

ensure_service_enabled() { _ensure_service system enable "$1"; }
ensure_service_start() { _ensure_service system start "$1"; }
ensure_service_disabled() { _ensure_service_remove system disable "$1"; }
ensure_service_stop() { _ensure_service_remove system stop "$1"; }

ensure_service_enabled_user() { _ensure_service user enable "$1"; }
ensure_service_start_user() { _ensure_service user start "$1"; }
ensure_service_disabled_user() { _ensure_service_remove user disable "$1"; }
ensure_service_stop_user() { _ensure_service_remove user stop "$1"; }
