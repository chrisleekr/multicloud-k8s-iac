#!/bin/bash

set -e


SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR=$(realpath "$SCRIPT_DIR/..")
REGISTRY_DOMAIN=${REGISTRY_DOMAIN:-"registry.hub.docker.com"}

# shellcheck source=/dev/null
source "$SCRIPT_DIR/common-func.sh"

# shellcheck source=/dev/null
[[ -f "$PROJECT_DIR/.env" ]] && source "$PROJECT_DIR/.env"

ARGS=${1:-""}

docker pull "$REGISTRY_DOMAIN/$REPO_NAME/$IMAGE_NAME:latest" || true

# shellcheck disable=SC2086
docker build . \
    ${ARGS} \
    --pull \
    --cache-from=$REGISTRY_DOMAIN/$REPO_NAME/$IMAGE_NAME:latest \
    --build-arg BUILDPLATFORM=$BUILD_PLATFORM \
    --build-arg BUILDARCH=$BUILD_ARCH \
    --progress plain \
    -t $REGISTRY_DOMAIN/$REPO_NAME/$IMAGE_NAME:latest
