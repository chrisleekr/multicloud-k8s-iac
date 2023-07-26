#!/bin/bash

set -e
set -o errexit

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
DIR=$(realpath "$SCRIPT_DIR/..")

# shellcheck source=common-func.sh
source "$SCRIPT_DIR/common-func.sh"

# Array of directories to validate
dirs=("google" "minikube")

for dir in "${dirs[@]}"; do
    log "Validating $dir Terraform..."
    pushd "workspaces/$dir/terraform"
    terraform init --backend=false
    terraform validate
    popd
done

log "All Terraform validated successfully!"
