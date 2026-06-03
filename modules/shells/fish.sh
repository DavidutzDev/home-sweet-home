#!/usr/bin/env bash

shells_fish::apply() {
  ensure_pacman "fish"

  stow_package "fish"
}

shells_fish::rollback() {
  ensure_remove_pacman "fish"

  unstow_package "fish"
}
