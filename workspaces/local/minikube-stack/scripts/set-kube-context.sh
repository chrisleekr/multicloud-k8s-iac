#!/bin/bash
#
# Fix Kubernetes context
#

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# shellcheck source=/dev/null
source "$SCRIPT_DIR/../../../../scripts/common-func.sh"

log "Retrieving the IP address of host.docker.internal..."
HOST_IP=$(nslookup host.docker.internal | grep 'Address: ' | tail -n1 | awk '{print $2}')

log "Adding host.docker.internal to /etc/hosts..."
echo "${HOST_IP}    control-plane.minikube.internal" | tee -a /etc/hosts

log "Updating the Kubernetes context..."
minikube update-context
sed -i 's/127.0.0.1/control-plane.minikube.internal/g' ~/.kube/config

log "Done."
kubectl get nodes
