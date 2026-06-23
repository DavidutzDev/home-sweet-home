#!/usr/bin/env bash

apps_evince::apply() {
  ensure_pacman "evince"

  xdg-mime default org.gnome.Evince.desktop application/pdf application/postscript image/vnd.djvu application/x-cbz application/x-cbr application/x-cb7 application/x-cbt application/x-dvi application/oxps application/vnd.ms-xpsdocument image/tiff
}

apps_vesktop::rollback() {
  ensure_remove_pacman "evince"
}
