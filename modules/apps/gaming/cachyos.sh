#!/usr/bin/env bash

apps_gaming_cachyos::apply() {
  if grep -qi "cachyos" /etc/os-release; then
    ensure_pacman "cachyos-gaming-meta"
    ensure_pacman "umu-launcher"
    ensure_pacman "proton-cachyos-slr"
    ensure_pacman "protonup-qt"
  fi
}

apps_gaming_cachyos::rollback() {
  if grep -qi "cachyos" /etc/os-release; then
    ensure_remove_pacman "protonup-qt"
    ensure_remove_pacman "proton-cachyos-slr"
    ensure_remove_pacman "umu-launcher"
    ensure_remove_pacman "cachyos-gaming-meta"
  fi
}
