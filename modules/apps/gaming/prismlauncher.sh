#!/usr/bin/env bash

apps_gaming_prismlauncher::apply() {
  ensure_pacman "prismlauncher"
}

apps_gaming_prismlauncher::rollback() {
  ensure_remove_pacman "prismlauncher"
}
