#!/usr/bin/env bash

WORKING_DIR="$TEMP_DIR/yay"
YAY_REPO="https://aur.archlinux.org/yay.git"

log_info "Ensuring system dependencies..."

ensure_pacman "dkms"
ensure_pacman "linux-headers"
ensure_pacman "git"
ensure_pacman "base-devel"

if ! is_installed "yay"; then
  log_info "Intalling package 'yay'"

  mkdir -p "$WORKING_DIR"
  pushd "$WORKING_DIR" &>/dev/null

  if ! [ -d "$WORKING_DIR/yay/.git" ]; then
    rm -fr yay
    git clone "$YAY_REPO" yay
    cd yay
  else
    cd yay
    git pull
  fi

  makepkg -si
  popd &>/dev/null
else
  log_info "Package 'yay' is already installed. Skipping."
fi
