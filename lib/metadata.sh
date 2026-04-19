#!/bin/bash
set -euo pipefail

PC_METADATA_DIR="/opt/pinecraft/metadata"

pc_metadata_save_install() {
  local install_path="$1"
  local flavour="$2"
  local version="$3"
  local build="$4"
  local required_java="$5"
  local seed_name="$6"
  local seed_value="$7"
  local run_user="$8"
  local gamemode="$9"
  local leveltype="${10}"
  local autoload="${11}"
  local install_action="${12}"
  local stamp

  mkdir -p "$PC_METADATA_DIR"
  stamp="$(date +%Y%m%d-%H%M%S)"

  jq -n \
    --arg install_path "$install_path" \
    --arg flavour "$flavour" \
    --arg minecraft_version "$version" \
    --arg build "$build" \
    --arg required_java "$required_java" \
    --arg seed_name "$seed_name" \
    --arg seed_value "$seed_value" \
    --arg run_user "$run_user" \
    --arg gamemode "$gamemode" \
    --arg leveltype "$leveltype" \
    --arg autoload "$autoload" \
    --arg install_action "$install_action" \
    --arg installed_at "$(date -Iseconds)" \
    '{
      install_path:$install_path,
      flavour:$flavour,
      minecraft_version:$minecraft_version,
      build:$build,
      required_java:$required_java,
      seed_name:$seed_name,
      seed_value:$seed_value,
      run_user:$run_user,
      gamemode:$gamemode,
      leveltype:$leveltype,
      autoload:$autoload,
      install_action:$install_action,
      active_path:"/srv/pinecraft/current",
      installed_at:$installed_at
    }' > "${PC_METADATA_DIR}/${stamp}.json"
}
