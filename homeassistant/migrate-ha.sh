#!/usr/bin/env bash
# Migrates a Home Assistant backup to a local Docker Compose setup.
#
# Extracts config from the backup into ~/homeassistant/config/ and creates
# docker-compose-homeassistant.yaml in this script's directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_FILE="$HOME/Downloads/ha/Automatic_backup_2026.2.3_2026-03-01_05.29_20004418.tar"
CONFIG_DIR="$HOME/homeassistant/config"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose-homeassistant.yaml"

# --- Validate ---
if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "ERROR: Backup file not found: $BACKUP_FILE"
  exit 1
fi

if [[ -d "$CONFIG_DIR" && -n "$(ls -A "$CONFIG_DIR" 2>/dev/null)" ]]; then
  echo "WARNING: $CONFIG_DIR already exists and is not empty."
  read -rp "Overwrite? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }
fi

# --- Extract HA version from backup manifest ---
HA_VERSION=$(tar -xOf "$BACKUP_FILE" ./backup.json | python3 -c "import sys,json; print(json.load(sys.stdin)['homeassistant']['version'])")
echo "Detected Home Assistant version: $HA_VERSION"

# --- Extract config ---
echo "Creating config directory: $CONFIG_DIR"
mkdir -p "$CONFIG_DIR"

echo "Extracting Home Assistant config from backup..."
# The inner homeassistant.tar.gz stores config under data/; strip that prefix.
tar -xOf "$BACKUP_FILE" homeassistant.tar.gz \
  | tar -xzf - --strip-components=1 -C "$CONFIG_DIR" data/

# Remove stale lock file if present
rm -f "$CONFIG_DIR/.ha_run.lock"

echo "Config extracted to $CONFIG_DIR"

# --- Write Docker Compose file ---
echo "Writing $COMPOSE_FILE"
cat > "$COMPOSE_FILE" <<EOF
services:
  homeassistant:
    image: ghcr.io/home-assistant/home-assistant:${HA_VERSION}
    container_name: homeassistant
    # host network is required for mDNS/device discovery (Chromecast, etc.)
    network_mode: host
    privileged: true
    environment:
      - TZ=America/New_York
    volumes:
      - $CONFIG_DIR:/config
      - /run/dbus:/run/dbus:ro
    restart: unless-stopped
EOF

echo ""
echo "Done! To start Home Assistant:"
echo "  docker compose -f $COMPOSE_FILE up -d"
echo ""
echo "Then open: http://localhost:8123/"
