#!/usr/bin/env bash

misc_docker::apply() {
  ensure_pacman "docker"

  sudo systemctl start docker.service
  sudo systemctl --now enable docker.service
}

misc_docker::rollback() {
  sudo systemctl stop docker.service
  sudo systemctl --now disable docker.service
  ensure_remove_pacman "docker"
}
