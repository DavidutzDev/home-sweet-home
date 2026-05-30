#!/usr/bin/env bash

MODULE_REQUIRES=()

fonts_jetbrains-nerd-mono::apply() {
  ensure_pacman "ttf-jetbrains-mono-nerd"
}

fonts_jetbrains-nerd-mono::rollback() {
  ensure_remove_pacman "ttf-jetbrains-mono-nerd"
}
