#!/usr/bin/env bash

apps_dolphin::apply() {
  ensure_pacman "dolphin"

  stow_package "dolphin"

  xdg-mime default dolphin.desktop inode/directory
}

apps_dolphin::rollback() {
  ensure_remove_pacman "dolphin"

  unstow_package "dolphin"
}
