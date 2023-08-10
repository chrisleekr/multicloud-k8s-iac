#!/bin/bash

set -e
set -o errexit

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
DIR=$(realpath "$SCRIPT_DIR/..")

# shellcheck source=common-func.sh
source "$SCRIPT_DIR/common-func.sh"

log "Load .env..."
# shellcheck source=../.env
[[ -f "$DIR/.env" ]] && source "$DIR/.env"

log "Build the docker image..."
# shellcheck source=/dev/null
source "${DIR}/scripts/docker-build.sh"

log "Stop the container if it exists..."
docker stop "multicloud-k8s-iac" -t1 || true
docker rm "multicloud-k8s-iac" || true

log "Launch the container..."
docker run -it --rm -d \
  --name "multicloud-k8s-iac" \
  --env-file ".env" \
  -v "$(pwd):/srv" \
  -v "$HOME/.minikube:/root/.minikube" \
  -v "/var/run/docker.sock:/var/run/docker.sock" \
  "$REGISTRY_DOMAIN/chrisleekr/multicloud-k8s-iac:latest"

log "*******"
log "You can now access to the container by executing the following command:"
log " $ docker exec -it \"multicloud-k8s-iac\" /bin/bash"
log "If you ran 'npm run docker:exec' or 'npm run docker:shell', you should see the container bash at /srv."
log "*******"
