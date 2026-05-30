#!/usr/bin/env bash

is_installed() {
  pacman -Qi "$1" &>/dev/null
}

_ensure() {
  local pkg="$1"
  local cmd="$2"
  local manager="$3"
  if ! is_installed "$pkg"; then
    log_info "Installing package '$pkg' via $manager..."
    if eval "$cmd"; then
      log_success "Package '$pkg' successfully installed."
    else
      log_error "Failed to install '$pkg' via $manager."
      return 1
    fi
  else
    log_info "Package '$pkg' is already installed. Skipping."
  fi
}

_ensure_remove() {
  local pkg="$1"
  local cmd="$2"
  local manager="$3"
  if is_installed "$pkg"; then
    log_info "Removing package '$pkg' via $manager..."
    if eval "$cmd"; then
      log_success "Package '$pkg' successfully removed."
    else
      log_error "Failed to remove '$pkg' via $manager."
      return 1
    fi
  else
    log_info "Package '$pkg' is not installed. Skipping."
  fi
}

ensure_pacman() {
  _ensure "$1" "sudo pacman -S --needed --noconfirm $1" "pacman"
}

ensure_aur() {
  _ensure "$1" "yay -S --needed --noconfirm $1" "yay"
}

ensure_remove_pacman() {
  _ensure_remove "$1" "sudo pacman -Rns --noconfirm $1" "pacman"
}

ensure_remove_aur() {
  _ensure_remove "$1" "yay -Rns --noconfirm $1" "yay"
}

# -- Flatpak integration

is_flatpak_installed() {
  flatpak info "$1" &>/dev/null
}

ensure_flatpak_available() {
  ensure_pacman "flatpak"
  if ! flatpak remotes --columns=name | grep -qx "flathub"; then
    log_info "Adding Flathub remote..."
    if sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; then
      log_success "Flathub remote added."
    else
      log_error "Failed to add Flathub remote."
      return 1
    fi
  fi

  local env_dir="$HOME/.config/environment.d"
  local env_file="$env_dir/flatpak.conf"
  local env_line='XDG_DATA_DIRS=${XDG_DATA_DIRS}:/var/lib/flatpak/exports/share:${HOME}/.local/share/flatpak/exports/share'
  if [[ -f "$env_file" ]] && grep -qF -- "$env_line" "$env_file"; then
    log_info "XDG_DATA_DIRS flatpak entry already present in '$env_file'. Skipping."
  else
    log_info "Adding flatpak XDG_DATA_DIRS entry to '$env_file'..."
    if mkdir -p "$env_dir" && printf '%s\n' "$env_line" >>"$env_file"; then
      log_success "XDG_DATA_DIRS flatpak entry added. Re-login required to take effect."
      recommend_reboot
    else
      log_error "Failed to write '$env_file'."
      return 1
    fi
  fi
}

ensure_flatpak() {
  command -v flatpak &>/dev/null || _die "Flatpak missing. Call 'ensure_flatpak_available' first."
  local app="$1"
  local remote="${2:-flathub}"
  if ! is_flatpak_installed "$app"; then
    log_info "Installing flatpak '$app' from '$remote'..."
    if flatpak install -y "$remote" "$app"; then
      log_success "Flatpak '$app' successfully installed."
    else
      log_error "Failed to install flatpak '$app'."
      return 1
    fi
  else
    log_info "Flatpak '$app' is already installed. Skipping."
  fi
}

ensure_remove_flatpak() {
  command -v flatpak &>/dev/null || _die "Flatpak missing. Call 'ensure_flatpak_available' first."
  local app="$1"
  if is_flatpak_installed "$app"; then
    log_info "Removing flatpak '$app'..."
    if flatpak uninstall -y "$app"; then
      log_success "Flatpak '$app' successfully removed."
    else
      log_error "Failed to remove flatpak '$app'."
      return 1
    fi
  else
    log_info "Flatpak '$app' is not installed. Skipping."
  fi
}
