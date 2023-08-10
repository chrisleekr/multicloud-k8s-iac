#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR=$(realpath "$SCRIPT_DIR/..")
REGISTRY_DOMAIN=${REGISTRY_DOMAIN:-"registry.hub.docker.com"}

# shellcheck source=common-func.sh
source "$SCRIPT_DIR/common-func.sh"

# shellcheck source=../.env
[[ -f "$PROJECT_DIR/.env" ]] && source "$PROJECT_DIR/.env"

ARGS=${1:-""}

docker pull "$REGISTRY_DOMAIN/chrisleekr/multicloud-k8s-iac:latest" || true

# shellcheck disable=SC2086
docker build . \
    ${ARGS} \
    --pull \
    --cache-from=$REGISTRY_DOMAIN/chrisleekr/multicloud-k8s-iac:latest \
    --progress plain \
    -t $REGISTRY_DOMAIN/chrisleekr/multicloud-k8s-iac:latest
