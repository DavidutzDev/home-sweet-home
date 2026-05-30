#!/usr/bin/env bash

apps_ai_claude::apply() {
  ensure_aur "claude-code"
}

apps_ai_claude::rollback() {
  ensure_remove_aur "claude-code"
}
