#!/usr/bin/env bash

apps_spotify::apply() {
  ensure_pacman "spotify-launcher"
}

apps_spotify::rollback() {
  ensure_remove_pacman "spotify-launcher"
}
