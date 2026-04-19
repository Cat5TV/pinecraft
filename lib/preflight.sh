#!/bin/bash
set -euo pipefail

PF_OS_ID=""
PF_OS_NAME=""
PF_OS_VERSION_ID=""
PF_OS_CODENAME=""
PF_ARCH=""
PF_IS_DEBIAN_BASED=0
PF_IS_SUPPORTED_OS=0
PF_IS_RPI=0
PF_IS_64BIT=0
PF_IS_CONTAINER=0
PF_RAM_MB=0
PF_DISK_AVAIL_MB=0
PF_NET_OK=0
PF_API_MOJANG_OK=0
PF_API_PAPER_OK=0
PF_API_PURPUR_OK=0
PF_API_FABRIC_OK=0
PF_API_FORGE_OK=0
PF_STATUS_LABEL="Unsupported"
PF_WARNING_TEXT=""
PF_ERROR_TEXT=""
PF_PI_BOARD=""
PF_PI_CONFIGFILE="/boot/config.txt"
PF_PI_OC_FREQ=0
PF_PI_OC_VOLT=0
PF_PI_OC_VOLT_DELTA=0
PF_PI_OC_FRIENDLY="Not Required"
PC_OC_ENABLE=0

pc_preflight_detect_os() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    PF_OS_ID="${ID:-unknown}"
    PF_OS_NAME="${PRETTY_NAME:-unknown}"
    PF_OS_VERSION_ID="${VERSION_ID:-unknown}"
    PF_OS_CODENAME="${VERSION_CODENAME:-unknown}"
  fi

  PF_ARCH="$(uname -m)"

  case "$PF_ARCH" in
    x86_64|amd64|aarch64|arm64)
      PF_IS_64BIT=1
      ;;
  esac

  if [[ -n "${ID_LIKE:-}" ]] && [[ " ${ID_LIKE} " == *" debian "* ]]; then
    PF_IS_DEBIAN_BASED=1
  elif [[ "$PF_OS_ID" == "debian" || "$PF_OS_ID" == "raspbian" ]]; then
    PF_IS_DEBIAN_BASED=1
  fi
}

pc_preflight_detect_pi() {
  local model=""
  local revision=""

  if [[ -f /proc/device-tree/model ]]; then
    model="$(tr -d '\0' < /proc/device-tree/model 2>/dev/null || true)"
  fi

  if grep -qi "raspberry pi" <<< "$model" 2>/dev/null; then
    PF_IS_RPI=1
  elif command -v vcgencmd > /dev/null 2>&1; then
    PF_IS_RPI=1
  fi

  if [[ -e /boot/firmware/config.txt ]]; then
    PF_PI_CONFIGFILE="/boot/firmware/config.txt"
  fi

  revision="$(awk '/^Revision/ {print $3}' /proc/cpuinfo 2>/dev/null | tail -n 1)"

  if [[ "$model" == *"Raspberry Pi 5"* || "$revision" == *"c04170"* || "$revision" == *"d04170"* ]]; then
    PF_PI_BOARD="Raspberry Pi 5"
    PF_PI_OC_FREQ=2400
    PF_PI_OC_VOLT_DELTA=250000
    PF_PI_OC_FRIENDLY="2.4 GHz"
  elif [[ "$model" == *"Raspberry Pi 400"* || "$revision" == *"c03130"* ]]; then
    PF_PI_BOARD="Raspberry Pi 400"
    PF_PI_OC_FREQ=2000
    PF_PI_OC_VOLT=6
    PF_PI_OC_FRIENDLY="2.0 GHz"
  elif [[ "$model" == *"Raspberry Pi 4"* || "$revision" == *"a03111"* || "$revision" == *"b03111"* || "$revision" == *"b03112"* || "$revision" == *"b03114"* || "$revision" == *"b03115"* || "$revision" == *"c03111"* || "$revision" == *"c03112"* || "$revision" == *"c03114"* || "$revision" == *"c03115"* || "$revision" == *"d03114"* || "$revision" == *"d03115"* ]]; then
    PF_PI_BOARD="Raspberry Pi 4"
    PF_PI_OC_FREQ=1900
    PF_PI_OC_VOLT=4
    PF_PI_OC_FRIENDLY="1.9 GHz"
  elif [[ "$model" == *"VIM4"* || "$revision" == *"VIM4"* ]]; then
    PF_PI_BOARD="Khadas VIM4"
    PF_PI_OC_FRIENDLY="Not Required"
  elif [[ $PF_IS_RPI -eq 1 ]]; then
    PF_PI_BOARD="Raspberry Pi"
  fi
}

pc_show_pi_overclock_prompt() {
  [[ $PF_IS_RPI -eq 1 ]] || return 0
  [[ $PF_PI_OC_FREQ -gt 0 ]] || return 0

  dialog --title "Confirmation" --yes-label "Enable" --no-label "Skip" --yesno "\nI will be modifying ${PF_PI_CONFIGFILE} to overclock this ${PF_PI_BOARD}.\n\nA backup copy of your existing config will be created first.\n\nContinue?\n" 12 66 && PC_OC_ENABLE=1 || true
}

pc_preflight_detect_container() {
  if grep -qaE 'docker|lxc|containerd' /proc/1/cgroup 2>/dev/null; then
    PF_IS_CONTAINER=1
  elif [[ -f /.dockerenv ]]; then
    PF_IS_CONTAINER=1
  fi
}

pc_preflight_check_resources() {
  PF_RAM_MB=$(awk '/MemTotal/ { printf "%d", $2/1024 }' /proc/meminfo)
  PF_DISK_AVAIL_MB=$(df -Pm / | awk 'NR==2 { print $4 }')
}

pc_preflight_check_network() {
  if curl -fsSL --connect-timeout 8 https://piston-meta.mojang.com/mc/game/version_manifest_v2.json > /dev/null 2>&1; then
    PF_NET_OK=1
    PF_API_MOJANG_OK=1
  fi

  curl -fsSL --connect-timeout 8 -H "User-Agent: Pinecraft/5.0" https://api.papermc.io/v2/projects/paper > /dev/null 2>&1 && PF_API_PAPER_OK=1 || true
  curl -fsSL --connect-timeout 8 https://api.purpurmc.org/v2/purpur > /dev/null 2>&1 && PF_API_PURPUR_OK=1 || true
  curl -fsSL --connect-timeout 8 https://meta.fabricmc.net/v2/versions/game > /dev/null 2>&1 && PF_API_FABRIC_OK=1 || true
  curl -fsSL --connect-timeout 8 https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json > /dev/null 2>&1 && PF_API_FORGE_OK=1 || true
}

pc_preflight_classify() {
  local warnings=()
  local errors=()

  if [[ $PF_IS_DEBIAN_BASED -eq 1 ]]; then
    PF_IS_SUPPORTED_OS=1
  else
    warnings+=("This does not appear to be a Debian Stable-based operating system.")
  fi

  if [[ $PF_IS_64BIT -eq 0 ]]; then
    warnings+=("32-bit systems will have limited server and Java support.")
  fi

  if [[ $PF_RAM_MB -lt 1500 ]]; then
    warnings+=("Very low system memory detected.")
  fi

  if [[ $PF_DISK_AVAIL_MB -lt 4096 ]]; then
    warnings+=("Low free disk space detected.")
  fi

  if [[ $PF_IS_CONTAINER -eq 1 ]]; then
    warnings+=("Container environment detected. Pinecraft is designed for bare-metal installs.")
  fi

  if [[ $PF_NET_OK -eq 0 ]]; then
    errors+=("Internet connectivity or Mojang manifest access failed.")
  fi

  if [[ ${#errors[@]} -gt 0 ]]; then
    PF_STATUS_LABEL="Unsupported, continue at your own risk"
  elif [[ ${#warnings[@]} -gt 0 ]]; then
    PF_STATUS_LABEL="Supported with warnings"
  else
    PF_STATUS_LABEL="Supported"
  fi

  PF_WARNING_TEXT="$(printf '%s\n' "${warnings[@]:-}" | sed '/^$/d')"
  PF_ERROR_TEXT="$(printf '%s\n' "${errors[@]:-}" | sed '/^$/d')"
}

pc_preflight_render_summary() {
  local api_lines=()
  [[ $PF_API_MOJANG_OK -eq 1 ]] && api_lines+=("• Mojang: OK\n") || api_lines+=("• Mojang: unavailable\n")
  [[ $PF_API_PAPER_OK -eq 1 ]] && api_lines+=("• Paper: OK\n") || api_lines+=("• Paper: unavailable\n")
  [[ $PF_API_PURPUR_OK -eq 1 ]] && api_lines+=("• Purpur: OK\n") || api_lines+=("• Purpur: unavailable\n")
  [[ $PF_API_FABRIC_OK -eq 1 ]] && api_lines+=("• Fabric: OK\n") || api_lines+=("• Fabric: unavailable\n")
  [[ $PF_API_FORGE_OK -eq 1 ]] && api_lines+=("• Forge: OK") || api_lines+=("• Forge: limited / best effort")

  local pi_text="No"
  [[ $PF_IS_RPI -eq 1 ]] && pi_text="Yes"

  local body="\n System preflight complete.\n\n OS: ${PF_OS_NAME}\n Architecture: ${PF_ARCH}\n Raspberry Pi: ${pi_text}\n Memory: ${PF_RAM_MB} MB\n Disk Free: ${PF_DISK_AVAIL_MB} MB\n Status: ${PF_STATUS_LABEL}\n"

  if [[ -n "$PF_PI_BOARD" ]]; then
    body+="\n Hardware: ${PF_PI_BOARD}\n"
    if [[ $PF_PI_OC_FREQ -gt 0 ]]; then
      body+=" Overclock Available: ${PF_PI_OC_FRIENDLY}\n"
    fi
  fi

  body+="\n API status:\n $(printf '%s\n ' "${api_lines[@]}")\n"

  if [[ -n "$PF_WARNING_TEXT" ]]; then
    body+="\n Warnings:\n ${PF_WARNING_TEXT}\n"
  fi

  if [[ -n "$PF_ERROR_TEXT" ]]; then
    body+="\n Problems:\n ${PF_ERROR_TEXT}\n"
  fi

  if [[ "$PF_STATUS_LABEL" == "Unsupported, continue at your own risk" ]]; then
    dialog --title "System Preflight" --yes-label "Continue Anyway" --no-label "Exit" --yesno "$body" 24 78 || exit 0
  else
    dialog --title "System Preflight" --msgbox "$body" 24 78
  fi
}

pc_apply_host_optimizations() {
  mkdir -p /etc/systemd/system.conf.d /etc/sysctl.d /etc/security/limits.d

  cat > /etc/security/limits.d/pinecraft.conf <<LIMITS
* soft nofile 1048576
* hard nofile 1048576
LIMITS

  cat > /etc/sysctl.d/99-pinecraft.conf <<SYSCTL
vm.swappiness = 10
fs.file-max = 2097152
net.core.somaxconn = 4096
SYSCTL

  sysctl --system > /dev/null 2>&1 || true

  if command -v systemctl > /dev/null 2>&1; then
    systemctl daemon-reload > /dev/null 2>&1 || true
  fi

  if [[ $PF_IS_RPI -eq 1 ]]; then
    pc_apply_pi_optimizations
  fi
}

pc_apply_pi_optimizations() {
  if command -v raspi-config > /dev/null 2>&1; then
    raspi-config nonint do_memory_split 16 > /dev/null 2>&1 || true
  fi

  for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [[ -w "$gov" ]] || continue
    echo performance > "$gov" 2>/dev/null || true
  done

  if [[ $PC_OC_ENABLE -eq 1 && -w "$PF_PI_CONFIGFILE" ]]; then
    local datestamp backup_file
    datestamp="$(date +%Y-%m-%d_%H-%M-%S)"
    backup_file="$(dirname "$PF_PI_CONFIGFILE")/config-${datestamp}.txt"
    cp "$PF_PI_CONFIGFILE" "$backup_file"

    if [[ $PF_PI_OC_VOLT -gt 0 ]]; then
      sed -i '/^over_voltage=/d' "$PF_PI_CONFIGFILE"
      echo "over_voltage=${PF_PI_OC_VOLT}" >> "$PF_PI_CONFIGFILE"
    fi

    if [[ $PF_PI_OC_VOLT_DELTA -gt 0 ]]; then
      sed -i '/^over_voltage_delta=/d' "$PF_PI_CONFIGFILE"
      echo "over_voltage_delta=${PF_PI_OC_VOLT_DELTA}" >> "$PF_PI_CONFIGFILE"
    fi

    if [[ $PF_PI_OC_FREQ -gt 0 ]]; then
      sed -i '/^arm_freq=/d' "$PF_PI_CONFIGFILE"
      echo "arm_freq=${PF_PI_OC_FREQ}" >> "$PF_PI_CONFIGFILE"
    fi

    sed -i '/^dtparam=audio=/d' "$PF_PI_CONFIGFILE"
    echo 'dtparam=audio=off' >> "$PF_PI_CONFIGFILE"
  fi
}

pc_preflight_run() {
  pc_preflight_detect_os
  pc_preflight_detect_pi
  pc_preflight_detect_container
  pc_preflight_check_resources
  pc_preflight_check_network
  pc_preflight_classify
}
