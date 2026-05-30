#!/usr/bin/env bash

MODULE_REQUIRES=()

hyprland_polkit::apply() {
  ensure_pacman "hyprpolkitagent"

  systemctl --user enable --now hyprpolkitagent.service
}

hyprland_polkit::rollback() {
  ensure_remove_pacman "hyprpolkitagent"
}
