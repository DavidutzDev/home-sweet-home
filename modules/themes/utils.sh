#!/usr/bin/env bash

themes_utils::apply() {
  ensure_aur "nwg-look"
}

themes_utils::rollback() {
  ensure_remove_aur "nwg-look"
}
