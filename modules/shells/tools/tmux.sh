#!/usr/bin/env bash

shells_tools_tmux::apply() {
  ensure_pacman "tmux"

  stow_package "tmux"
}

shells_tools_tmux::rollback() {
  ensure_remove_pacman "tmux"

  unstow_package "tmux"
}
