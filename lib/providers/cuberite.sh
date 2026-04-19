#!/bin/bash
set -euo pipefail

pc_cuberite_download_url_for_arch() {
  local arch="${PF_ARCH:-$(uname -m)}"
  case "$arch" in
    x86_64|amd64)
      echo "https://download.cuberite.org/linux-x86_64/Cuberite.tar.gz"
      ;;
    i386|i686)
      echo "https://download.cuberite.org/linux-i386/Cuberite.tar.gz"
      ;;
    armv7l|armv7|armhf)
      echo "https://download.cuberite.org/linux-armhf-raspbian/Cuberite.tar.gz"
      ;;
    aarch64|arm64)
      echo "https://download.cuberite.org/linux-aarch64/Cuberite.tar.gz"
      ;;
    *)
      return 1
      ;;
  esac
}

pc_cuberite_list_versions() {
  printf '%s
'     "1.12.2"     "1.12.1"     "1.12"     "1.11.2"     "1.11"     "1.10.2"     "1.10"     "1.9.4"     "1.9.2"     "1.9"     "1.8.9"     "1.8.8"     "1.8"
}

pc_cuberite_resolve() {
  local version="${1:-latest}"
  local url

  url="$(pc_cuberite_download_url_for_arch)" || return 1
  jq -n --arg u "$url" --arg j "Cuberite.tar.gz" --arg v "$version" '{download_url:$u, jar_name:$j, minecraft_version:$v}'
}
