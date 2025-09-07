#!/bin/bash

set -e
set -o errexit

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
DIR=$(realpath "$SCRIPT_DIR/..")

# shellcheck source=common-func.sh
source "$SCRIPT_DIR/common-func.sh"

log "Load .env..."
# shellcheck source=/dev/null
[[ -f "$DIR/.env" ]] && source "$DIR/.env"

log "Build the docker image..."
# shellcheck source=/dev/null
source "${DIR}/scripts/docker-build.sh"

log "Stop the container if it exists..."
docker stop "$IMAGE_NAME" -t1 || true
docker rm "$IMAGE_NAME" || true

log "Launch the container..."
docker run -it --rm -d \
  --name "$IMAGE_NAME" \
  --env-file ".env" \
  -v "$(pwd):/srv" \
  -v "$HOME/.minikube:/root/.minikube" \
  -v "/var/run/docker.sock:/var/run/docker.sock" \
  "$REGISTRY_DOMAIN/$REPO_NAME/$IMAGE_NAME:latest"

log "*******"
log "You can now access to the container by executing the following command:"
log " $ docker exec -it \"$IMAGE_NAME\" /bin/bash"
log "If you ran 'npm run docker:exec' or 'npm run docker:shell', you should see the container bash at /srv."
log "*******"
