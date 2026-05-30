RECOMMEND_REBOOT=false

_die() {
  log_error "$1"
  exit 1
}

ensure_home_dirs() {
  log_info "Ensuring home directories exists for user '$USER'."
  xdg-user-dirs-update
}

recommend_reboot() {
  RECOMMEND_REBOOT=true
}

prompt_reboot_if_recommended() {
  [[ "$RECOMMEND_REBOOT" == true ]] || return 0

  log_info "Some changes require a reboot to take full effect."
  local reply
  read -rp "Reboot now? [y/N] " reply
  case "$reply" in
  [yY] | [yY][eE][sS])
    log_info "Rebooting..."
    sudo reboot
    ;;
  *)
    log_info "Skipping reboot. Remember to reboot (or re-login) later."
    ;;
  esac
}
