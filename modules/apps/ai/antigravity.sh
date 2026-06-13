#!/usr/bin/env bash

apps_ai_antigravity::apply() {
  ensure_aur "antigravity-cli"
}

apps_ai_antigravity::rollback() {
  ensure_remove_aur "antigravity-cli"
}
