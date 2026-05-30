#!/usr/bin/env bash

apps_evince::apply() {
  ensure_pacman "evince"
}

apps_vesktop::rollback() {
  ensure_remove_pacman "evince"
}
