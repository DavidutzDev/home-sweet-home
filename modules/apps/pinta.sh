#!/usr/bin/env bash

apps_pinta::apply() {
  ensure_pacman "pinta"
}

apps_vesktop::rollback() {
  ensure_remove_pacman "pinta"
}
