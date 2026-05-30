#!/usr/bin/env bash

apps_discord::apply() {
  ensure_pacman "discord"
}

apps_vesktop::rollback() {
  ensure_remove_pacman "discord"
}
