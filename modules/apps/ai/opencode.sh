#!/usr/bin/env bash

apps_ai_opencode::apply() {
  ensure_pacman "opencode"
}

apps_ai_opencode::rollback() {
  ensure_remove_pacman "opencode"
}
