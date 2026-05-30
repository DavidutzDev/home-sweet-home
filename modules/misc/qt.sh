#!/usr/bin/env bash

misc_qt::apply() {
  ensure_pacman "qt5ct"
  ensure_pacman "qt6ct"

  stow_package "qt"
}

misc_qt::rollback() {
  ensure_remove_pacman "qt5ct"
  ensure_remove_pacman "qt6ct"

  unstow_package "qt"
}
