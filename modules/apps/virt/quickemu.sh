#!/usr/bin/env bash

apps_virt_quickemu::apply() {
  ensure_pacman "qemu-desktop"
  ensure_aur "quickemu"
}

apps_virt_quickemu::rollback() {
  ensure_remove_aur "quickemu"
}
