#!/usr/bin/env bash

DOTFILES_REPO="git@github.com:DavidutzDev/dotfiles-test"
DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_BRANCH="main"

ensure_home_dirs

ensure_dotfiles_repo
ensure_flatpak_available

require "hyprland/core"
require "fonts/jetbrains-nerd-mono"
require "themes/catppuccin"
require "misc/qt"

require "apps/terminals/ghostty"
require "apps/editors/neovim"

require "shells/fish"
require "shells/tools/tmux"
require "shells/tools/devops"

require "apps/thunar"
require "apps/evince"
require "apps/pinta"
require "apps/spotify"
require "apps/obs-studio"
require "apps/discord"
require "apps/zen-browser"
require "apps/localsend"
require "apps/sunshine"

require "apps/peripherals/piper"

require "apps/editors/intellij"

require "misc/docker"
require "misc/tailscale"

require "apps/ai/opencode"
require "apps/ai/claude"
require "apps/ai/gemini"

require "apps/gaming/steam"
require "apps/gaming/roblox"

stow_package "bin"
