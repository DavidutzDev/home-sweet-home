#!/usr/bin/env bash

hyprland_swaync::apply() {
  ensure_pacman "swaync"

  stow_package "swaync"

  killall "swaync" &>/dev/null || true
  swaync &
  disown
}

hyprland_swaync::rollback() {
  killall "swaync" &>/dev/null || true

  ensure_remove_pacman "swaync"

  unstow_package "swaync"
}
