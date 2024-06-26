#!/bin/bash
SERVICE_NAME="traefik"
SERVICE_VERSION="v3.1"

set -e

SERVICE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
echo "[$SERVICE_NAME] $SERVICE_VERSION ($(git rev-parse --short HEAD))"
cd $SERVICE_DIR

# CORE
source ./core/core.sh

# ATTACHMENTS
att_setup() {
  docker network create traefik &>/dev/null || true

  if [[ ! -d "$SERVICES_DIR/$CONFIG_PATH" ]]; then
    read -p "Enter 'DASHBOARD_DOMAIN': " DASHBOARD_DOMAIN

    mkdir -p $SERVICES_DIR/$CONFIG_PATH
    # cp $SERVICE_DIR/dashboard.example.yml $SERVICES_DIR/$CONFIG_PATH/dashboard.yml
    # sed -i "s/\`\${DASHBOARD_DOMAIN}\`/$DASHBOARD_DOMAIN/g" $SERVICES_DIR/$CONFIG_PATH/dashboard.yml
    generate $SERVICE_DIR/dashboard.example.yml $SERVICES_DIR/$CONFIG_PATH/dashboard.yml
  fi
}

att_configure() {
  generate templates/traefik.yml generated/traefik.yml
}

# MAIN
main "$@"
