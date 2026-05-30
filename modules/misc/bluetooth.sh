#!/usr/bin/env bash

misc_bluetooth::apply() {
  ensure_aur "overskride-bin"

  ensure_service_start bluetooth.service
  ensure_service_enable bluetooth.service
}

misc_bluetooth::rollback() {
  ensure_service_stop bluetooth.service
  ensure_service_disable bluetooth.service
  ensure_remove_aur "overskride-bin"
}
