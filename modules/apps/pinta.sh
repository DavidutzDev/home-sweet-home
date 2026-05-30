#!/usr/bin/env bash

apps_pinta::apply() {
  ensure_aur "pinta"
}

apps_pinta::rollback() {
  ensure_remove_aur "pinta"
}
