#!/usr/bin/env bash

MODULE_REQUIRES=("themes/utils")

themes_catppuccin::apply() {
  ensure_aur "catppuccin-gtk-theme-mocha"
}

themes_catppuccin::rollback() {
  ensure_remove_aur "catppuccin-gtk-theme-mocha"
}
