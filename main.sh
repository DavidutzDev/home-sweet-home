#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
HOSTS_DIR="$SCRIPT_DIR/hosts"
TEMP_DIR="/tmp/home-sweet-home"

mkdir -p "$TEMP_DIR"

source lib/colors.sh
source lib/logging.sh
source lib/utils.sh
source lib/packages.sh
source lib/services.sh
source lib/dotfiles.sh
source lib/modules.sh

HOST_NAME=""
ACTION="apply"
STRICT=false

usage() {
  cat <<USAGE
Usage: $0 --host <hostname> [--apply | --rollback]
 
Options:
  -h, --host <name>   Host to configure (required)
      --apply         Apply all modules (default)
      --rollback      Rollback all modules
      --strict        Abort on first module failure
      --help          Show this help
 
Examples:
  $0 --host desktop-btw
  $0 --host desktop-btw --apply
  $0 --host desktop-btw --rollback
USAGE
}

while [[ $# -gt 0 ]]; do
  case $1 in
  -h | --host)
    HOST_NAME="$2"
    shift
    shift
    ;;
  --apply)
    ACTION="apply"
    shift
    ;;
  --rollback)
    ACTION="rollback"
    shift
    ;;
  --strict)
    STRICT=true
    shift
    ;;
  --help)
    usage
    exit 0
    ;;
  *)
    log_error "Unkown option: $1"
    exit 1
    ;;
  esac
done

if [[ -z "$HOST_NAME" ]]; then
  log_error "Missing required argument: --host <hostname>"
  usage
  exit 1
fi

TARGET="$HOSTS_DIR/$HOST_NAME/main.sh"
if [[ ! -f "$TARGET" ]]; then
  log_error "Failed to get configuration for host '$HOST_NAME'"
  exit 1
fi

case "$ACTION" in
apply)
  log_info "Configuring host '$HOST_NAME', the opperation may take a few minutes..."
  ;;
rollback)
  log_info "Rolling back host '$HOST_NAME'..."
  ;;
esac

SECONDS=0

source modules/core.sh
source "$TARGET"

case "$ACTION" in
apply) apply_modules ;;
rollback) rollback_modules ;;
esac

log_success "$(printf 'Done in %dm %ds' $((SECONDS / 60)) $((SECONDS % 60)))"

prompt_reboot_if_recommended
