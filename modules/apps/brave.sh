#!/usr/bin/env bash

apps_brave::apply() {
  ensure_pacman "brave"
}

apps_brave::rollback() {
  ensure_remove_pacman "brave-bin"
}
