#!/usr/bin/env bash

shells_tools_devops::apply() {
  ensure_pacman "kubectl"
}

shells_tools_devops::rollback() {
  ensure_remove_pacman "kubectl"
}
