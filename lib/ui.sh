#!/bin/bash
set -euo pipefail

pc_infobox() {
  local text="$1"
  if command -v dialog > /dev/null 2>&1; then
    dialog --title "Pinecraft 5.0" --infobox "${text}" 5 72
  else
    echo "$text"
  fi
}

pc_phase() {
  local text="$1"
  pc_infobox "$text"
}
