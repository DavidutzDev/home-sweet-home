#!/usr/bin/env bash

misc_docker::apply() {
  ensure_pacman "docker"
  ensure_pacman "docker-compose"

  ensure_service_start docker.service
  ensure_service_enabled docker.service
}

misc_docker::rollback() {
  ensure_service_stop docker.service
  ensure_service_disabled docker.service
  ensure_remove_pacman "docker"
  ensure_remove_pacman "docker-compose"
}
