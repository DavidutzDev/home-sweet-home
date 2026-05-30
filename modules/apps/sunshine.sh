#!/usr/bin/env bash

apps_sunshine::apply() {
  ensure_pacman "sunshine"

  sudo setcap cap_sys_admin+p $(readlink -f $(which sunshine))

  systemctl --user start app-dev.lizardbyte.app.Sunshine
  systemctl --user --now enable app-dev.lizardbyte.app.Sunshine
}

apps_sunshine::rollback() {
  systemctl --user stop app-dev.lizardbyte.app.Sunshine
  systemctl --user --now disable app-dev.lizardbyte.app.Sunshine

  ensure_remove_pacman "sunshine"
}
