#!/bin/bash
set -euo pipefail

pc_provider_is_available() {
  local flavour="$1"
  case "$flavour" in
    vanilla) [[ ${PF_API_MOJANG_OK:-0} -eq 1 ]] ;;
    paper) [[ ${PF_API_PAPER_OK:-0} -eq 1 ]] ;;
    purpur) [[ ${PF_API_PURPUR_OK:-0} -eq 1 ]] ;;
    fabric) [[ ${PF_API_FABRIC_OK:-0} -eq 1 ]] ;;
    forge) return 0 ;;
    spigot) [[ ${PF_NET_OK:-0} -eq 1 ]] ;;
    cuberite)
      [[ ${PF_NET_OK:-0} -eq 1 ]] || return 1
      pc_cuberite_download_url_for_arch > /dev/null 2>&1
      ;;
    *) return 1 ;;
  esac
}

pc_provider_menu_entries() {
  local -a all=()
  all=(
    'vanilla|Vanilla|Official Minecraft server. Most basic setup. No plugins.'
    'paper|Paper|Fast, optimized server with plugin support. Recommended for most users.'
    'purpur|Purpur|Based on Paper, with extra gameplay and configuration options.'
    'spigot|Spigot|Classic Bukkit-style plugin server with broad plugin compatibility.'
    'fabric|Fabric|Lightweight modding platform for modern modded servers.'
    'forge|Forge|Popular modding platform for many classic and modern mods.'
    'cuberite|Cuberite|Extremely lightweight alternative server for low-resource systems.'
  )

  local line key
  for line in "${all[@]}"; do
    key="${line%%|*}"
    pc_provider_is_available "$key" || continue
    printf '%s
' "$line"
  done
}

pc_provider_hidden_details() {
  local -a hidden=()

  [[ ${PF_API_MOJANG_OK:-0} -eq 1 ]] || hidden+=("Vanilla is hidden because Mojang version discovery is currently unavailable.")
  [[ ${PF_API_PAPER_OK:-0} -eq 1 ]] || hidden+=("Paper is hidden because the Paper API is currently unavailable.")
  [[ ${PF_API_PURPUR_OK:-0} -eq 1 ]] || hidden+=("Purpur is hidden because the Purpur API is currently unavailable.")
  [[ ${PF_API_FABRIC_OK:-0} -eq 1 ]] || hidden+=("Fabric is hidden because the Fabric API is currently unavailable.")
  [[ ${PF_NET_OK:-0} -eq 1 ]] || hidden+=("Spigot and Cuberite are hidden because general network access is currently unavailable.")
  pc_cuberite_download_url_for_arch > /dev/null 2>&1 || hidden+=("Cuberite is hidden because this CPU architecture is not supported by the official Cuberite downloads.")

  printf '%s
' "${hidden[@]:-}" | sed '/^$/d'
}

pc_provider_list_versions() {
  local flavour="$1"
  case "$flavour" in
    vanilla) pc_vanilla_list_versions ;;
    paper) pc_paper_list_versions ;;
    purpur) pc_purpur_list_versions ;;
    spigot) pc_spigot_list_versions ;;
    fabric) pc_fabric_list_versions ;;
    forge) pc_forge_list_versions ;;
    cuberite) pc_cuberite_list_versions ;;
    *) return 1 ;;
  esac
}

pc_provider_supports_build_selection() {
  local flavour="$1"
  case "$flavour" in
    paper|purpur|fabric) return 0 ;;
    *) return 1 ;;
  esac
}

pc_provider_build_label() {
  local flavour="$1"
  case "$flavour" in
    fabric) echo "Loader" ;;
    *) echo "Build" ;;
  esac
}

pc_provider_list_builds() {
  local flavour="$1"
  local version="$2"
  case "$flavour" in
    paper) pc_paper_list_builds "$version" ;;
    purpur) pc_purpur_list_builds "$version" ;;
    fabric) pc_fabric_list_builds "$version" ;;
    *) return 1 ;;
  esac
}

pc_live_install_dir() {
  echo "/srv/pinecraft/server"
}

pc_prepare_upgrade_preserve() {
  local install_dir="$1"
  local preserve_dir="$2"
  local item
  local -a keep=(
    world
    world_nether
    world_the_end
    world_*
    world-*
    plugins
    mods
    config
    logs
    crash-reports
    server.properties
    eula.txt
    ops.json
    whitelist.json
    banned-ips.json
    banned-players.json
    banned-users.json
    usercache.json
    permissions.yml
    bukkit.yml
    spigot.yml
    paper*.yml
    purpur.yml
    fabric-server-launcher.properties
  )

  mkdir -p "$preserve_dir"
  shopt -s nullglob dotglob
  for item in "${keep[@]}"; do
    for path in "${install_dir}/${item}"; do
      [[ -e "$path" ]] || continue
      mv "$path" "$preserve_dir/"
    done
  done
  shopt -u nullglob dotglob

  find "$install_dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
}

pc_restore_upgrade_preserve() {
  local install_dir="$1"
  local preserve_dir="$2"

  [[ -d "$preserve_dir" ]] || return 0
  shopt -s nullglob dotglob
  for path in "$preserve_dir"/*; do
    mv "$path" "$install_dir/"
  done
  shopt -u nullglob dotglob
  rm -rf "$preserve_dir"
}

pc_resolve_install_dir() {
  local flavour="$1"
  local version="$2"
  local action="${3:-new}"
  local install_dir

  install_dir="$(pc_live_install_dir)"
  mkdir -p /srv/pinecraft

  case "$action" in
    upgrade|replace|new)
      echo "$install_dir"
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

pc_install_selected_server() {
  local run_user="$1"
  local flavour="$2"
  local version="$3"
  local build="$4"
  local seed_name="$5"
  local seed_value="$6"
  local required_java="$7"
  local gamemode="${8:-survival}"
  local leveltype="${9:-normal}"
  local install_action="${10:-new}"
  local existing_install="${11:-}"
  local install_dir
  local preserve_dir=""

  install_dir="$(pc_resolve_install_dir "$flavour" "$version" "$install_action")" || return 1

  if [[ "$install_action" == "replace" && -d "$install_dir" ]]; then
    rm -rf "$install_dir"
  fi

  mkdir -p "$install_dir"

  if [[ "$install_action" == "upgrade" && -d "$install_dir" ]]; then
    preserve_dir="$(mktemp -d /tmp/pinecraft-preserve.XXXXXX)"
    pc_prepare_upgrade_preserve "$install_dir" "$preserve_dir"
  fi

  case "$flavour" in
    vanilla)
      pc_install_vanilla "$install_dir" "$version" "$seed_name" "$seed_value" "$required_java" "$gamemode" "$leveltype" > /dev/null
      ;;
    paper)
      pc_install_paper "$install_dir" "$version" "$build" "$seed_name" "$seed_value" "$required_java" "$gamemode" "$leveltype" > /dev/null
      ;;
    purpur)
      pc_install_purpur "$install_dir" "$version" "$build" "$seed_name" "$seed_value" "$required_java" "$gamemode" "$leveltype" > /dev/null
      ;;
    fabric)
      pc_install_fabric "$install_dir" "$version" "$build" "$seed_name" "$seed_value" "$required_java" "$gamemode" "$leveltype" > /dev/null
      ;;
    forge)
      pc_install_forge "$install_dir" "$version" "$build" "$seed_name" "$seed_value" "$required_java" "$gamemode" "$leveltype" > /dev/null
      ;;
    spigot)
      pc_install_spigot "$install_dir" "$version" "$seed_name" "$seed_value" "$required_java" "$gamemode" "$leveltype" > /dev/null
      ;;
    cuberite)
      pc_install_cuberite "$install_dir" "$version" "$seed_name" "$seed_value" "$gamemode" "$leveltype" > /dev/null
      ;;
    *)
      return 1
      ;;
  esac

  if [[ -n "$preserve_dir" ]]; then
    pc_restore_upgrade_preserve "$install_dir" "$preserve_dir"
  fi

  if [[ -n "$run_user" ]] && id "$run_user" > /dev/null 2>&1; then
    chown -R "$run_user":"$run_user" "$install_dir"
  fi

  echo "${pcver}" > "${install_dir}/cat5tv.ver"
  echo "$install_dir"
}

pc_write_server_properties() {
  local install_dir="$1"
  local seed_name="$2"
  local seed_value="$3"
  local gamemode="${4:-survival}"
  local leveltype="${5:-normal}"
  local motd="Pinecraft ${pcver}"

  cat > "${install_dir}/server.properties" <<PROPS
motd=${motd}
level-seed=${seed_value}
gamemode=${gamemode}
level-type=${leveltype}
enable-query=true
difficulty=normal
view-distance=7
allow-flight=true
enable-rcon=false
PROPS

  cat > "${install_dir}/eula.txt" <<EULA
# By changing the setting below to TRUE you are indicating your agreement to the Minecraft EULA.
# Pinecraft set this to TRUE during installation so the server can start.
# Read the full Minecraft EULA here: https://aka.ms/MinecraftEULA
#
# Summary: Running a Minecraft server is subject to Mojang's and Microsoft's terms.
# If you do not agree, stop the server and remove this installation.
eula=true
EULA
}

pc_write_run_script() {
  local install_dir="$1"
  local required_java="$2"
  local command_line="$3"

  cat > "${install_dir}/server" <<SCRIPT
#!/bin/bash
cd "${install_dir}"
export JAVA_HOME=/opt/pinecraft/java/${required_java}
exec "/opt/pinecraft/java/${required_java}/bin/java" ${command_line}
SCRIPT
  chmod +x "${install_dir}/server"
}

pc_install_vanilla() {
  local install_dir="$1" version="$2" seed_name="$3" seed_value="$4" required_java="$5" gamemode="${6:-survival}" leveltype="${7:-normal}"
  local resolved url jar
  resolved="$(pc_vanilla_resolve "$version")"
  url="$(jq -r '.download_url' <<< "$resolved")"
  jar="$(jq -r '.jar_name' <<< "$resolved")"
  curl -fsSL "$url" -o "${install_dir}/${jar}"
  pc_write_server_properties "$install_dir" "$seed_name" "$seed_value" "$gamemode" "$leveltype" "$gamemode" "$leveltype" "$gamemode" "$leveltype" "$gamemode" "$leveltype" "$gamemode" "$leveltype" "$gamemode" "$leveltype" "$gamemode" "$leveltype"
  pc_write_run_script "$install_dir" "$required_java" "-Xms1G -Xmx2G -jar ${jar} nogui"
}

pc_install_paper() {
  local install_dir="$1" version="$2" build="$3" seed_name="$4" seed_value="$5" required_java="$6" gamemode="${7:-survival}" leveltype="${8:-normal}"
  local resolved url jar
  resolved="$(pc_paper_resolve "$version" "$build")"
  url="$(jq -r '.download_url' <<< "$resolved")"
  jar="$(jq -r '.jar_name' <<< "$resolved")"
  curl -fsSL -H "User-Agent: Pinecraft/${pcver}" "$url" -o "${install_dir}/${jar}"
  pc_write_server_properties "$install_dir" "$seed_name" "$seed_value"
  pc_write_run_script "$install_dir" "$required_java" "-Xms1G -Xmx2G -jar ${jar} nogui"
}

pc_install_purpur() {
  local install_dir="$1" version="$2" build="$3" seed_name="$4" seed_value="$5" required_java="$6" gamemode="${7:-survival}" leveltype="${8:-normal}"
  local resolved url jar
  resolved="$(pc_purpur_resolve "$version" "$build")"
  url="$(jq -r '.download_url' <<< "$resolved")"
  jar="$(jq -r '.jar_name' <<< "$resolved")"
  curl -fsSL "$url" -o "${install_dir}/${jar}"
  pc_write_server_properties "$install_dir" "$seed_name" "$seed_value"
  pc_write_run_script "$install_dir" "$required_java" "-Xms1G -Xmx2G -jar ${jar} nogui"
}

pc_install_fabric() {
  local install_dir="$1" version="$2" build="$3" seed_name="$4" seed_value="$5" required_java="$6" gamemode="${7:-survival}" leveltype="${8:-normal}"
  local resolved url jar loader
  resolved="$(pc_fabric_resolve "$version" "$build")"
  url="$(jq -r '.download_url' <<< "$resolved")"
  jar="$(jq -r '.jar_name' <<< "$resolved")"
  loader="$(jq -r '.loader' <<< "$resolved")"
  curl -fsSL "$url" -o "${install_dir}/${jar}"
  pushd "$install_dir" > /dev/null
  "/opt/pinecraft/java/${required_java}/bin/java" -jar "$jar" server -mcversion "$version" -loader "$loader" -downloadMinecraft
  popd > /dev/null
  pc_write_server_properties "$install_dir" "$seed_name" "$seed_value"
  pc_write_run_script "$install_dir" "$required_java" "-Xms1G -Xmx2G -jar fabric-server-launch.jar nogui"
}

pc_install_forge() {
  local install_dir="$1" version="$2" build="$3" seed_name="$4" seed_value="$5" required_java="$6" gamemode="${7:-survival}" leveltype="${8:-normal}"
  local resolved url jar
  resolved="$(pc_forge_resolve "$version" "$build")" || {
    dialog --title "Forge" --msgbox "
 Forge automatic version discovery is unavailable right now.

 Forge installs are best-effort because upstream automation can be unpredictable.
" 10 72
    return 1
  }
  url="$(jq -r '.installer_url' <<< "$resolved")"
  jar="$(jq -r '.jar_name' <<< "$resolved")"
  curl -fsSL "$url" -o "${install_dir}/${jar}"
  pushd "$install_dir" > /dev/null
  "/opt/pinecraft/java/${required_java}/bin/java" -jar "$jar" --installServer
  popd > /dev/null
  pc_write_server_properties "$install_dir" "$seed_name" "$seed_value"

  if [[ -f "${install_dir}/run.sh" ]]; then
    cat > "${install_dir}/server" <<SCRIPT
#!/bin/bash
cd "${install_dir}"
export JAVA_HOME=/opt/pinecraft/java/${required_java}
export PATH="/opt/pinecraft/java/${required_java}/bin:$PATH"
exec ./run.sh nogui
SCRIPT
    chmod +x "${install_dir}/server"
    return 0
  fi

  if [[ -f "${install_dir}/unix_args.txt" ]]; then
    cat > "${install_dir}/server" <<SCRIPT
#!/bin/bash
cd "${install_dir}"
export JAVA_HOME=/opt/pinecraft/java/${required_java}
exec "/opt/pinecraft/java/${required_java}/bin/java" @unix_args.txt nogui
SCRIPT
    chmod +x "${install_dir}/server"
    return 0
  fi

  local runjar
  runjar="$(find "$install_dir" -maxdepth 1 -type f -name 'forge-*.jar' | head -n 1)"
  [[ -n "$runjar" ]] || runjar="${jar}"
  pc_write_run_script "$install_dir" "$required_java" "-Xms1G -Xmx2G -jar $(basename "$runjar") nogui"
}

pc_install_spigot() {
  local install_dir="$1" version="$2" seed_name="$3" seed_value="$4" required_java="$5" gamemode="${6:-survival}" leveltype="${7:-normal}"
  local resolved url jar
  resolved="$(pc_spigot_resolve "$version")"
  url="$(jq -r '.buildtools_url' <<< "$resolved")"
  jar="$(jq -r '.jar_name' <<< "$resolved")"
  curl -fsSL "$url" -o "${install_dir}/${jar}"

  if ! command -v git > /dev/null 2>&1; then
    dialog --title "Spigot" --msgbox "
 git is required to build Spigot with BuildTools.
" 8 52
    return 1
  fi

  pushd "$install_dir" > /dev/null
  "/opt/pinecraft/java/${required_java}/bin/java" -jar "$jar" --rev "$version"
  popd > /dev/null
  pc_write_server_properties "$install_dir" "$seed_name" "$seed_value"
  local runjar
  runjar="$(find "$install_dir" -maxdepth 1 -type f -name 'spigot-*.jar' | sort -V | tail -n 1)"
  [[ -n "$runjar" ]] || {
    dialog --title "Spigot" --msgbox "
 BuildTools did not produce a Spigot jar.
" 8 52
    return 1
  }
  pc_write_run_script "$install_dir" "$required_java" "-Xms1G -Xmx2G -jar $(basename "$runjar") nogui"
}

pc_install_cuberite() {
  local install_dir="$1" version="$2" seed_name="$3" seed_value="$4" gamemode="${5:-survival}" leveltype="${6:-normal}"
  local resolved url jar
  resolved="$(pc_cuberite_resolve "$version")" || {
    dialog --title "Cuberite" --msgbox "
 This CPU architecture is not supported by the official Cuberite Linux downloads.
" 8 64
    return 1
  }
  url="$(jq -r '.download_url' <<< "$resolved")"
  jar="$(jq -r '.jar_name' <<< "$resolved")"
  curl -fsSL "$url" -o "${install_dir}/${jar}"
  tar -xzf "${install_dir}/${jar}" -C "$install_dir"
  cat > "${install_dir}/server" <<SCRIPT
#!/bin/bash
cd "${install_dir}"
exec ./Cuberite
SCRIPT
  chmod +x "${install_dir}/server"
}
