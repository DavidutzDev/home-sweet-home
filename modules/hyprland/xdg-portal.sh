#!/usr/bin/env bash

MODULE_REQUIRES=()

hyprland_xdg-portal::apply() {
  # prerequisites
  ensure_pacman "pipewire"
  ensure_pacman "wireplumber"

  ensure_pacman "xdg-desktop-portal-hyprland"
}

hyprland_xdg-portal::rollback() {
  ensure_remove_pacman "xdg-desktop-portal-hyprland"
}
