#!/usr/bin/env bash

apps_editors_neovim::apply() {
  ensure_pacman "neovim"
}

apps_editors_neovim::rollback() {
  ensure_remove_pacman "neovim"
}
