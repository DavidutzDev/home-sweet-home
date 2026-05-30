#!/usr/bin/env bash

apps_localsend::apply() {
  ensure_pacman "localsend"
}

apps_localsend::rollback() {
  ensure_remove_pacman "localsend"
}
