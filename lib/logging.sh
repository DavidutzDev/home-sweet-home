#!/usr/bin/env bash

log_info() {
  echo -e "${OVERLAY}[INFO]${RESET} ${TEXT}$1${RESET}"
}

log_success() {
  echo -e "${GREEN}[ OK ]${RESET} ${TEXT}$1${RESET}"
}

log_warn() {
  echo -e "${YELLOW}[WARN] $1${RESET}"
}

log_error() {
  echo -e "${RED}${BOLD}[ERROR] $1${RESET}" >&2
}
