#!/usr/bin/env bash

apps_gaming_steam::apply() {
  ensure_pacman "steam"
}

apps_gaming_steam::rollback() {
  ensure_remove_pacman "steam"
}
