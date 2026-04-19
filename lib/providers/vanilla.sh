#!/bin/bash
set -euo pipefail

PC_MOJANG_MANIFEST="https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
PC_VANILLA_SERVER_CACHE="$PC_CACHE_DIR/vanilla-server-versions.cache"

pc_vanilla_manifest() {
  local cache_file="$PC_CACHE_DIR/mojang-version-manifest-v2.json"
  pc_cache_get "$PC_MOJANG_MANIFEST" "$cache_file"
}

pc_vanilla_build_server_cache() {
  local manifest line id meta_url resolved meta_file
  manifest="$(pc_vanilla_manifest)" || return 1
  : > "$PC_VANILLA_SERVER_CACHE"

  while IFS=$'	' read -r id meta_url; do
    [[ -n "$id" && -n "$meta_url" ]] || continue
    meta_file="$PC_CACHE_DIR/vanilla-meta-${id//[^A-Za-z0-9._-]/_}.json"
    resolved="$(pc_cache_get "$meta_url" "$meta_file" 360 2>/dev/null || true)"
    if [[ -n "$resolved" ]] && jq -e '.downloads.server.url' > /dev/null 2>&1 <<< "$resolved"; then
      printf '%s
' "$id" >> "$PC_VANILLA_SERVER_CACHE"
    fi
  done < <(jq -r '.versions[] | select(.type=="release" or .type=="old_beta" or .type=="old_alpha") | [.id,.url] | @tsv' <<< "$manifest")
}

pc_vanilla_list_versions() {
  if ! pc_cache_fresh "$PC_VANILLA_SERVER_CACHE" "$PC_CACHE_TTL_MINUTES" || [[ ! -s "$PC_VANILLA_SERVER_CACHE" ]]; then
    pc_vanilla_build_server_cache || return 1
  fi
  cat "$PC_VANILLA_SERVER_CACHE"
}

pc_vanilla_list_release_versions() {
  pc_vanilla_manifest | jq -r '.versions[] | select(.type=="release") | .id'
}

pc_vanilla_resolve() {
  local version="$1"
  local manifest meta_url resolved meta_file

  manifest="$(pc_vanilla_manifest)"
  meta_url="$(jq -r --arg v "$version" '.versions[] | select(.id==$v) | .url' <<< "$manifest" | head -n 1)"
  [[ -n "$meta_url" && "$meta_url" != "null" ]] || return 1

  meta_file="$PC_CACHE_DIR/vanilla-meta-${version//[^A-Za-z0-9._-]/_}.json"
  resolved="$(pc_cache_get "$meta_url" "$meta_file")"
  jq -e '.downloads.server.url' > /dev/null <<< "$resolved" || return 1
  jq -r '{download_url: .downloads.server.url, jar_name: ("server-" + .id + ".jar")}' <<< "$resolved"
}
