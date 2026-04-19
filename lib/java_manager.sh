#!/bin/bash
set -euo pipefail

PC_JAVA_BASE="/opt/pinecraft/java"

pc_arch_adoptium() {
  case "$(uname -m)" in
    x86_64|amd64) echo "x64" ;;
    aarch64|arm64) echo "aarch64" ;;
    armv7l|armv7) echo "arm" ;;
    *) echo "x64" ;;
  esac
}

pc_java_required_for_mc() {
  local v="$1"

  if [[ "$v" =~ ^b[0-9] || "$v" =~ ^a[0-9] ]]; then
    echo 8
    return
  fi

  if [[ "$v" =~ ^[0-9]{2}\.[0-9]+ ]]; then
    echo 21
    return
  fi

  if [[ "$v" =~ ^1\.([0-9]+)(\.([0-9]+))? ]]; then
    local minor="${BASH_REMATCH[1]}"
    local patch="${BASH_REMATCH[3]:-0}"

    if (( minor <= 16 )); then
      echo 8
    elif (( minor == 17 )); then
      echo 16
    elif (( minor == 18 || minor == 19 )); then
      echo 17
    elif (( minor == 20 )); then
      if (( patch >= 6 )); then echo 21; else echo 17; fi
    else
      echo 21
    fi
    return
  fi

  echo 21
}

pc_ensure_java_major() {
  local major="$1"
  local dest="${PC_JAVA_BASE}/${major}"
  local tmp="/tmp/pinecraft-java-${major}.tar.gz"
  local arch
  local url

  [[ -x "${dest}/bin/java" ]] && return 0

  arch="$(pc_arch_adoptium)"
  url="https://api.adoptium.net/v3/binary/latest/${major}/ga/linux/${arch}/jre/hotspot/normal/eclipse"

  mkdir -p "$PC_JAVA_BASE"
  curl -fsSL -L "$url" -o "$tmp"
  rm -rf "$dest"
  mkdir -p "$dest"
  tar -xzf "$tmp" -C "$dest" --strip-components=1
  rm -f "$tmp"

  [[ -x "${dest}/bin/java" ]]
}

pc_java_bin_for_major() {
  local major="$1"
  echo "${PC_JAVA_BASE}/${major}/bin/java"
}
