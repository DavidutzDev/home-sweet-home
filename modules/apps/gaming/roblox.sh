#!/usr/bin/env bash

apps_gaming_roblox::apply() {
  ensure_flatpak "org.vinegarhq.Sober"

  flatpak override --user --device=input org.vinegarhq.Sober
}

apps_gaming_roblox::rollback() {
  ensure_remove_flatpak "org.vinegarhq.Sober"
}
