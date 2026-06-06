#!/usr/bin/env bash

misc_tailscale::apply() {
  ensure_pacman "tailscale"

  ensure_service_start tailscaled.service
  ensure_service_enabled tailscaled.service
}

misc_tailscale::rollback() {
  ensure_service_stop tailscaled.service
  ensure_service_disabled tailscaled.service

  ensure_remove_pacman "tailscale"
}
