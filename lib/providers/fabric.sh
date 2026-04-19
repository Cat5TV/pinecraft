#!/bin/bash
set -euo pipefail

pc_fabric_list_versions() {
  local cache_file="$PC_CACHE_DIR/fabric-game-versions.json"
  pc_cache_get "https://meta.fabricmc.net/v2/versions/game" "$cache_file" | jq -r '.[] | select(.stable==true) | .version'
}

pc_fabric_list_builds() {
  local version="$1"
  local cache_file="$PC_CACHE_DIR/fabric-loader-versions.json"
  pc_cache_get "https://meta.fabricmc.net/v2/versions/loader" "$cache_file" | jq -r '.[] | select(.stable==true) | .version' | head -n 1
}

pc_fabric_resolve() {
  local version="$1"
  local build="$2"
  local loader installer
  local loader_cache="$PC_CACHE_DIR/fabric-loader-versions.json"
  local installer_cache="$PC_CACHE_DIR/fabric-installer-versions.json"
  if [[ "$build" == "latest" ]]; then
    loader="$(pc_cache_get "https://meta.fabricmc.net/v2/versions/loader" "$loader_cache" | jq -r '.[] | select(.stable==true) | .version' | head -n 1)"
  else
    loader="$build"
  fi
  installer="$(pc_cache_get "https://meta.fabricmc.net/v2/versions/installer" "$installer_cache" | jq -r '.[] | select(.stable==true) | .version' | head -n 1)"
  jq -n --arg loader "$loader" --arg installer "$installer" --arg version "$version" '{loader:$loader, installer:$installer, minecraft_version:$version, jar_name:("fabric-installer-" + $installer + ".jar"), download_url:("https://maven.fabricmc.net/net/fabricmc/fabric-installer/" + $installer + "/fabric-installer-" + $installer + ".jar")}'
}
