#!/usr/bin/env bash

apps_zen-browser::apply() {
  ensure_pacman "zen-browser"

  log_info "[HINT] Don't forget to create a symlink of '~/.zen-chrome' in your Default Profile"
  stow_package "zen-browser"
}

apps_zeb-browser::rollback() {
  ensure_remove_pacman "zen-browser"

  unstow_package "zen-browser"
}
