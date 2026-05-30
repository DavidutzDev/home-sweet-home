#!/usr/bin/env bash

apps_vesktop::apply() {
  ensure_pacman "vesktop"
}

apps_vesktop::rollback() {
  ensure_remove_pacman "vesktop"
}
