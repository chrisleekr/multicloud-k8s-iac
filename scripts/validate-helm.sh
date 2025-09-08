#!/bin/bash

set -e
set -o errexit

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
DIR=$(realpath "$SCRIPT_DIR/..")

# shellcheck source=/dev/null
source "$SCRIPT_DIR/common-func.sh"

log "Looking for Helm charts..."

# Find sub folders that contains `Chart.yaml` file
# shellcheck disable=SC2207
charts=($(find "$DIR" -type f -name Chart.yaml -exec dirname {} \;))

for chart in "${charts[@]}"; do
    log "Found Helm chart: $chart"

    log "Validating Helm chart..."
    pushd "$chart"
    helm lint
    # shellcheck disable=SC2094
    helm template . >template
    popd
    log "Helm chart validated: $chart"
done

log "All Helm charts validated successfully!"
