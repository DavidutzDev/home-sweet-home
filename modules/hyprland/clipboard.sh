#!/usr/bin/env bash

MODULE_REQUIRES=()

hyprland_clipboard::apply() {
  ensure_pacman "cliphist"
  ensure_pacman "wtype"
}

hyprland_clipboard::rollback() {
  ensure_remove_pacman "cliphist"
  ensure_remove_pacman "wtype"
}
