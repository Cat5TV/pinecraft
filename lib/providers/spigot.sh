#!/bin/bash
set -euo pipefail

pc_spigot_list_versions() {
  pc_vanilla_list_release_versions
}

pc_spigot_resolve() {
  local version="$1"
  jq -n --arg version "$version" '{minecraft_version:$version, buildtools_url:"https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar", jar_name:"BuildTools.jar"}'
}
