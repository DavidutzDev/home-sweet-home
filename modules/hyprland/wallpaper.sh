#!/usr/bin/env bash

MODULE_REQUIRES=()

hyprland_wallpaper::apply() {
  ensure_pacman "awww"

  stow_package "wallpapers"

  if ! pgrep -x "awww-daemon" >/dev/null; then
    awww-daemon &
    disown
  fi
}

hyprland_wallpaper::rollback() {
  ensure_remove_pacman "awww"

  unstow_package "wallpapers"

  killall awww-daemon
}
