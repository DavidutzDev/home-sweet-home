#!/usr/bin/env bash

MODULE_REQUIRES=()

hyprland_waybar::apply() {
  ensure_pacman "waybar"

  stow_package "waybar"

  # Reload
  killall "waybar" &>/dev/null || true
  waybar &
  disown
}

hyprland_waybar::rollback() {
  killall "waybar" &>/dev/null || true

  ensure_remove_pacman "waybar"

  unstow_package "waybar"
}
