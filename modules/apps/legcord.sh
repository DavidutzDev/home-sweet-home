#!/usr/bin/env bash

apps_legcord::apply() {
  ensure_aur "legcord-git"
}

apps_vesktop::rollback() {
  ensure_remove_aur "legcord-git"
}
