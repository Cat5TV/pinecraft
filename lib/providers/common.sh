#!/bin/bash
set -euo pipefail

PC_CACHE_DIR="${TMPDIR:-/tmp}/pinecraft-cache"
PC_CACHE_TTL_MINUTES="${PC_CACHE_TTL_MINUTES:-360}"
mkdir -p "$PC_CACHE_DIR"

pc_cache_fresh() {
  local file="$1"
  local max_age_minutes="${2:-$PC_CACHE_TTL_MINUTES}"

  [[ -f "$file" ]] || return 1
  find "$file" -mmin "-${max_age_minutes}" | grep -q .
}

pc_cache_get() {
  local url="$1"
  local file="$2"
  local max_age_minutes="${3:-$PC_CACHE_TTL_MINUTES}"
  local user_agent="${4:-}"

  mkdir -p "$(dirname "$file")"

  if ! pc_cache_fresh "$file" "$max_age_minutes"; then
    if [[ -n "$user_agent" ]]; then
      curl -fsSL -H "User-Agent: ${user_agent}" "$url" -o "$file"
    else
      curl -fsSL "$url" -o "$file"
    fi
  fi

  cat "$file"
}
