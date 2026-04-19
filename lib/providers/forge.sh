#!/bin/bash
set -euo pipefail

pc_forge_list_versions() {
  local promos_cache="$PC_CACHE_DIR/forge-promotions.json"
  local promos
  local -a available=()
  local version

  promos="$(pc_cache_get "https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json" "$promos_cache" | jq -r '.promos | keys[]' | sed 's/-recommended$//; s/-latest$//' | awk 'NF && !seen[$0]++')"

  while IFS= read -r version; do
    [[ -n "$version" ]] || continue
    if grep -Fxq "$version" <<< "$promos"; then
      available+=("$version")
    fi
  done < <(pc_vanilla_list_release_versions)

  printf '%s
' "${available[@]}" | awk 'NF'
}

pc_forge_resolve() {
  local version="$1"
  local build="$2"
  local full
  local promos_cache="$PC_CACHE_DIR/forge-promotions.json"

  if [[ "$build" == "latest" ]]; then
    full="$(pc_cache_get "https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json" "$promos_cache" | jq -r --arg v "${version}-recommended" '.promos[$v] // empty')"
    [[ -n "$full" ]] || full="$(pc_cache_get "https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json" "$promos_cache" | jq -r --arg v "${version}-latest" '.promos[$v] // empty')"
    [[ -n "$full" ]] || return 1
    build="$full"
  fi

  jq -n --arg v "$version" --arg b "$build" '{minecraft_version:$v, build:$b, installer_url:("https://maven.minecraftforge.net/net/minecraftforge/forge/" + $v + "-" + $b + "/forge-" + $v + "-" + $b + "-installer.jar"), jar_name:("forge-" + $v + "-" + $b + "-installer.jar")}'
}
