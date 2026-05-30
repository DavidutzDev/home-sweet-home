#!/usr/bin/env bash

apps_terminals_ghostty::apply() {
  ensure_pacman "ghostty"

  stow_package "ghostty"
}

apps_terminals_ghostty::rollback() {
  ensure_remove_pacman "ghostty"

  unstow_package "ghostty"
}
