#!/bin/bash

set -e
set -o errexit

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck source=/dev/null
source "$SCRIPT_DIR/common-func.sh"

# Array of directories to validate
dirs=("aws" "gcp" "minikube")

for dir in "${dirs[@]}"; do
    log "Validating $dir Terraform..."
    pushd "workspaces/$dir/terraform"
    terraform init --backend=false
    terraform validate
    popd
done

log "All Terraform validated successfully!"
