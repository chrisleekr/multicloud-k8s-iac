#!/bin/bash
#
# Add/Update hosts entry
# Reference: https://gist.github.com/jacobtomlinson/4b835d807ebcea73c6c8f602613803d4
#

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck source=/dev/null
source "$SCRIPT_DIR/../../../../scripts/common-func.sh"

INGRESS_HOST=$(kubectl --context=minikube --all-namespaces=true get ingress -o jsonpath='{.items[0].spec.rules[*].host}')

MINIKUBE_IP=$(minikube ip)

API_HOSTS_ENTRY="$MINIKUBE_IP $INGRESS_HOST"

log "Add the following entry to your /etc/hosts file:"
echo "$API_HOSTS_ENTRY"
