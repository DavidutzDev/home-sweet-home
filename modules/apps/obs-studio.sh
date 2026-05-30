#!/usr/bin/env bash

apps_obs-studio::apply() {
  ensure_pacman "obs-studio"
}

apps_obs-studio::rollback() {
  ensure_remove_pacman "obs-studio"
}
