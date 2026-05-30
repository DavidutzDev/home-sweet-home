#!/usr/bin/env bash

apps_peripherals_piper::apply() {
  ensure_pacman "piper"
}

apps_peripherals_piper::rollback() {
  ensure_remove_pacman "piper"
}
