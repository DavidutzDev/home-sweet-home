#!/usr/bin/env bash

MODULE_REQUIRES=("misc/ouch")

apps_thunar::apply() {
  ensure_pacman "thunar"
  ensure_pacman "tumbler"
  ensure_pacman "gvfs"
  ensure_pacman "gvfs-mtp"
  ensure_pacman "ntfs-3g"

  stow_package "thunar"

  xdg-mime default thunar.desktop inode/directory
}

apps_thunar::rollback() {
  ensure_remove_pacman "thunar"

  unstow_package "thunar"
}
