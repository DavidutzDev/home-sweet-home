#!/usr/bin/env bash

hyprland_screenshot::apply() {
  ensure_pacman "hyprshot"
  ensure_pacman "satty"
}

hyprland_screenshot::rollback() {
  ensure_remove_pacman "hyprshot"
  ensure_remove_pacman "satty"
}
