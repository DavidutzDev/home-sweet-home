#!/usr/bin/env bash

apps_ai_gemini::apply() {
  ensure_pacman "gemini-cli"
}

apps_ai_gemini::rollback() {
  ensure_remove_pacman "gemini-cli"
}
