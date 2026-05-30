#!/usr/bin/env bash

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"

ensure_dotfiles_repo() {
  if [[ -z "${DOTFILES_REPO:-}" ]]; then
    log_warn "DOTFILES_REPO has not been set, skipping dotfiles repo"
    return 0
  fi

  ensure_pacman "git"
  ensure_pacman "stow"

  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log_info "Updating dotfiles repo in '$DOTFILES_DIR'..."
    if git -C "$DOTFILES_DIR" pull --ff-only origin "$DOTFILES_BRANCH"; then
      log_success "Dotfiles repo updated."
    else
      log_error "Failed to update dotfiles repo (uncommited changes? wrong branch?)."
      return 1
    fi
  elif [[ -e "$DOTFILES_DIR" ]]; then
    log_error "'$DOTFILES_DIR' exists but is not a git repo. Aborting."
    return 1
  else
    log_info "Cloning dotfiles repo from '$DOTFILES_REPO'..."
    if git clone --branch "$DOTFILES_BRANCH" "$DOTFILES_REPO" "$DOTFILES_DIR"; then
      log_success "Dotfiles repo cloned to '$DOTFILES_DIR'."
    else
      log_error "Failed to clone dotfiles repo."
      return 1
    fi
  fi
}

_check_stow_package() {
  local pkg="$1"

  [[ -d "$DOTFILES_DIR" ]] || _die "Dotfiles dir '$DOTFILES_DIR' is missing. Call ensure_dotfiles_repo first."
  [[ -d "$DOTFILES_DIR/$pkg" ]] || _die "Stow package '$pkg' not found in '$DOTFILES_DIR'."
}

stow_package() {
  local pkg="$1"
  local target="${2:-$HOME}"

  _check_stow_package "$pkg"

  log_info "Stowing '$pkg' -> '$target'..."
  if stow --dir="$DOTFILES_DIR" --target="$target" --adopt --restow "$pkg"; then
    log_success "Package '$pkg' stowed."
  else
    log_error "Failed to stow '$pkg'."
    exit 1
  fi
}

unstow_package() {
  local pkg="$1"
  local target="${2:-$HOME}"

  _check_stow_package "$pkg"

  log_info "Unstowing '$pkg' from '$target'..."
  if stow --dir="$DOTFILES_DIR" --target="$target" --delete "$pkg"; then
    log_success "Package '$pkg' unstowed."
  else
    log_error "Failed to unstow '$pkg'."
    exit 1
  fi
}

copy_package() {
  local pkg="$1"
  local target="${2:-$HOME}"
  _check_stow_package "$pkg"
  local src="$DOTFILES_DIR/$pkg"
  log_info "Copying '$pkg' -> '$target'..."
  local ok=1
  while IFS= read -r -d '' dir; do
    mkdir -p "$target/${dir#"$src"/}" || ok=0
  done < <(find "$src" -mindepth 1 -type d -print0)
  while IFS= read -r -d '' file; do
    local rel="${file#"$src"/}"
    rm -rf -- "$target/$rel"
    cp -r -- "$file" "$target/$rel" || ok=0
  done < <(find "$src" \( -type f -o -type l \) -print0)
  if [[ "$ok" -eq 1 ]]; then
    log_success "Package '$pkg' copied."
  else
    log_error "Failed to copy '$pkg'."
    exit 1
  fi
}
