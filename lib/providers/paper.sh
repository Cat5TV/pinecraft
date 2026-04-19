#!/bin/bash
set -euo pipefail

pc_paper_list_versions() {
  local cache_file="$PC_CACHE_DIR/paper-versions.json"
  pc_cache_get "https://api.papermc.io/v2/projects/paper" "$cache_file" "$PC_CACHE_TTL_MINUTES" "Pinecraft/5.0" | jq -r '.versions[]' | tac
}

pc_paper_list_builds() {
  local version="$1"
  local cache_file="$PC_CACHE_DIR/paper-builds-${version}.json"
  pc_cache_get "https://api.papermc.io/v2/projects/paper/versions/${version}" "$cache_file" "$PC_CACHE_TTL_MINUTES" "Pinecraft/5.0" | jq -r '.builds[] | tostring' | tac
}

pc_paper_resolve() {
  local version="$1"
  local build="$2"
  if [[ "$build" == "latest" ]]; then
    build="$(pc_paper_list_builds "$version" | head -n 1)"
  fi
  jq -n --arg u "https://api.papermc.io/v2/projects/paper/versions/${version}/builds/${build}/downloads/paper-${version}-${build}.jar" --arg j "paper-${version}-${build}.jar" --arg b "$build" '{download_url:$u, jar_name:$j, build:$b}'
}
