#!/usr/bin/env bash

apps_editors_intellij::apply() {
  ensure_pacman "intellij-idea-community-edition"
}

apps_editors_intellij::rollback() {
  ensure_remove_pacman "intellij-idea-community-edition"
}
