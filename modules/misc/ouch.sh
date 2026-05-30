#!/usr/bin/env bash

misc_ouch::apply() {
  ensure_pacman "ouch"
}

misc_ouch::rollback() {
  ensure_remove_pacman "ouch"
}
