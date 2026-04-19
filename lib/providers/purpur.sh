#!/bin/bash
set -euo pipefail

pc_purpur_list_versions() {
  local cache_file="$PC_CACHE_DIR/purpur-versions.json"
  pc_cache_get "https://api.purpurmc.org/v2/purpur" "$cache_file" | jq -r '.versions[]' | tac
}

pc_purpur_list_builds() {
  local version="$1"
  local cache_file="$PC_CACHE_DIR/purpur-builds-${version}.json"
  pc_cache_get "https://api.purpurmc.org/v2/purpur/${version}" "$cache_file" | jq -r '.builds.all[] | tostring' | tac
}

pc_purpur_resolve() {
  local version="$1"
  local build="$2"
  if [[ "$build" == "latest" ]]; then
    build="$(pc_purpur_list_builds "$version" | head -n 1)"
  fi
  jq -n --arg u "https://api.purpurmc.org/v2/purpur/${version}/${build}/download" --arg j "purpur-${version}-${build}.jar" --arg b "$build" '{download_url:$u, jar_name:$j, build:$b}'
}
