#!/usr/bin/env bash

misc_docker::apply() {
  ensure_pacman "docker"

  ensure_service_start docker.service
  ensure_service_enable docker.service
}

misc_docker::rollback() {
  ensure_service_stop docker.service
  ensure_service_disable docker.service
  ensure_remove_pacman "docker"
}
