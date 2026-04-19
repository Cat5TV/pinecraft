#!/bin/bash
set -euo pipefail

PC_ROOT_DIR="/srv/pinecraft"
PC_INSTALLS_DIR="${PC_ROOT_DIR}/installs"
PC_CURRENT_LINK="${PC_ROOT_DIR}/current"
PC_LOG_DIR="${PC_ROOT_DIR}/logs"
PC_SCREEN_NAME="pinecraft"
PC_SERVICE_NAME="pinecraft.service"

pc_runtime_screen_exists() {
  local run_user="${1:-$(pc_runtime_run_user)}"
  su - "$run_user" -c "screen -wipe > /dev/null 2>&1; screen -list 2>/dev/null | grep -q '[.]${PC_SCREEN_NAME}[[:space:]]'"
}

pc_runtime_run_user() {
  if [[ -L "$PC_CURRENT_LINK" ]]; then
    stat -c '%U' "$(readlink -f "$PC_CURRENT_LINK")" 2>/dev/null || echo root
  else
    echo root
  fi
}

pc_runtime_activate_install() {
  local install_dir="$1"
  mkdir -p "$PC_ROOT_DIR" "$PC_INSTALLS_DIR" "$PC_LOG_DIR"
  ln -sfn "$install_dir" "$PC_CURRENT_LINK"
}

pc_runtime_install_helpers() {
  cat > /usr/local/bin/pinecraft <<'SCRIPT'
#!/bin/bash
set -euo pipefail

PC_ROOT_DIR="/srv/pinecraft"
PC_CURRENT_LINK="${PC_ROOT_DIR}/current"
PC_SCREEN_NAME="pinecraft"

pc_current_target() {
  readlink -f "$PC_CURRENT_LINK"
}

pc_require_current() {
  if [[ ! -L "$PC_CURRENT_LINK" ]] || [[ ! -x "$(pc_current_target)/server" ]]; then
    echo "No active Pinecraft installation found."
    exit 1
  fi
}

pc_run_user() {
  stat -c '%U' "$(pc_current_target)" 2>/dev/null || echo root
}

pc_screen_exists() {
  local run_user
  run_user="$(pc_run_user)"
  su - "$run_user" -c "screen -list 2>/dev/null | grep -q '[.]${PC_SCREEN_NAME}[[:space:]]'"
}

case "${1:-}" in
  start)
    pc_require_current
    if pc_screen_exists; then
      echo "Pinecraft server already appears to be running."
      exit 0
    fi
    if ss -ltn 2>/dev/null | grep -q ':25565 '; then
      echo "Port 25565 already appears to be in use by another process."
      exit 1
    fi
    local_user="$(pc_run_user)"
    target="$(pc_current_target)"
    exec su - "$local_user" -c "cd '$target' && exec screen -dmS '${PC_SCREEN_NAME}' ./server"
    ;;
  stop)
    pc_require_current
    local_user="$(pc_run_user)"
    if ! su - "$local_user" -c "screen -list 2>/dev/null | grep -q '[.]${PC_SCREEN_NAME}[[:space:]]'"; then
      echo "Pinecraft server is not currently running."
      exit 0
    fi
    su - "$local_user" -c "screen -S '${PC_SCREEN_NAME}' -p 0 -X stuff \"stop$(printf '\r')\""
    for _ in $(seq 1 60); do
      sleep 1
      if ! su - "$local_user" -c "screen -list 2>/dev/null | grep -q '[.]${PC_SCREEN_NAME}[[:space:]]'"; then
        exit 0
      fi
    done
    echo "Pinecraft server did not stop within the expected time."
    exit 1
    ;;
  console)
    local_user="$(pc_run_user)"
    if ! pc_screen_exists; then
      echo "Pinecraft server is not currently running."
      exit 1
    fi
    exec su - "$local_user" -c "exec screen -r '${PC_SCREEN_NAME}'"
    ;;
  status)
    pc_require_current
    echo "Active install: $(pc_current_target)"
    echo "Linux user: $(pc_run_user)"
    if pc_screen_exists; then
      echo "Screen session: ${PC_SCREEN_NAME} (running)"
    else
      echo "Screen session: ${PC_SCREEN_NAME} (stopped)"
    fi
    if ss -ltn 2>/dev/null | grep -q ':25565 '; then
      echo "Port 25565: in use"
    else
      echo "Port 25565: free"
    fi
    ;;
  restart)
    "$0" stop || true
    sleep 3
    exec "$0" start
    ;;
  *)
    echo "Usage: pinecraft {start|stop|restart|console|status}"
    exit 1
    ;;
esac
SCRIPT
  chmod +x /usr/local/bin/pinecraft
}

pc_runtime_install_service() {
  cat > /etc/systemd/system/${PC_SERVICE_NAME} <<'UNIT'
[Unit]
Description=Pinecraft Minecraft Server
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/pinecraft start
ExecStop=/usr/local/bin/pinecraft stop
TimeoutStartSec=0
TimeoutStopSec=120

[Install]
WantedBy=multi-user.target
UNIT

  if command -v systemctl > /dev/null 2>&1; then
    systemctl daemon-reload > /dev/null 2>&1 || true
    systemctl enable ${PC_SERVICE_NAME} > /dev/null 2>&1 || true
  fi
}
