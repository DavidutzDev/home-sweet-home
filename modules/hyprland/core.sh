#!/usr/bin/env bash

MODULE_REQUIRES=("hyprland/polkit" "hyprland/waybar" "hyprland/hyprlock" "hyprland/xdg-portal" "hyprland/wallpaper" "hyprland/walker" "hyprland/swaync" "hyprland/screenshot" "hyprland/clipboard")

hyprland_core::apply() {
  ensure_pacman "hyprland"

  stow_package "hyprland"

  # Reload
  hyprctl reload
}
hyprland_core::rollback() {
  ensure_remove_pacman "hyprland"

  unstow_package "hyprland"
}
