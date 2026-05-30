#!/usr/bin/env bash

apps_sunshine::apply() {
  ensure_pacman "sunshine"

  sudo setcap cap_sys_admin+p $(readlink -f $(which sunshine))

  ensure_service_start_user app-dev.lizardbyte.app.Sunshine
  ensure_service_Start_user app-dev.lizardbyte.app.Sunshine
}

apps_sunshine::rollback() {
  ensure_service_stop_user app-dev.lizardbyte.app.Sunshine
  ensure_service_disable_user app-dev.lizardbyte.app.Sunshine

  ensure_remove_pacman "sunshine"
}
