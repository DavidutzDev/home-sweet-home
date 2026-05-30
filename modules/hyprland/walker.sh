#!/usr/bin/env bash

MODULE_REQUIRES=()

hyprland_walker::apply() {
  ensure_pacman "openbsd-netcat"

  ensure_aur "walker-bin"
  ensure_aur "elephant-bin"

  ensure_aur "elephant-providerlist-bin"
  ensure_aur "elephant-desktopapplications-bin"
  ensure_aur "elephant-menus-bin"

  stow_package "walker"
}

hyprland_walker::rollback() {
  ensure_remove_aur "walker-bin"
  ensure_remove_aur "elephant-bin"

  ensure_remove_aur "elephant-providerlist-bin"
  ensure_remove_aur "elephant-desktopapplications-bin"
  ensure_remove_aur "elephant-menus-bin"

  unstow_package "walker"
}
