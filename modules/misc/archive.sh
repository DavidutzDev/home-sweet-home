#!/usr/bin/env bash

misc_archive::apply() {
  ensure_pacman "ark"
  ensure_pacman "7zip"
}

misc_archive::rollback() {
  ensure_remove_pacman "ark"
  ensure_remove_pacman "7zip"
}
