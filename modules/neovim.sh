#!/usr/bin/env bash

MODULE_REQUIRES=()

neovim::apply() {
  ensure_pacman "neovim"
}

neovim::rollback() {
  ensure_remove_pacman "neovim"
}
