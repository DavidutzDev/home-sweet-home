#!/usr/bin/env bash

MODULE_REQUIRES=()

hyprland_hyprlock::apply() {
  ensure_pacman "hyprlock"
}

hyprland_hyprlock::rollback() {
  ensure_remove_pacman "hyprlock"
}
