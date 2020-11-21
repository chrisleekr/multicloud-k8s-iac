#!/bin/bash
#
# Add/Update hosts entry
# Reference: https://gist.github.com/jacobtomlinson/4b835d807ebcea73c6c8f602613803d4
#

set -xe

INGRESS_HOST=$(kubectl --context=minikube --all-namespaces=true get ingress -o jsonpath='{.items[0].spec.rules[*].host}')

MINIKUBE_IP=$(minikube ip)

HOST_OS=${HOST_OS:-"linux"}

function detect_os {
    # Detect the OS name
    case "$(uname -s)" in
        Darwin)
            HOST_OS="darwin"
        ;;
        Linux)
            HOST_OS="linux"
        ;;
        *)
            echo "Unsupported host OS. Must be Linux or Mac OS X." >&2
            exit 1
        ;;
    esac
}

detect_os

HOSTS_PATH=/etc/hosts

if [ $HOST_OS = "darwin" ]
then
    HOSTS_PATH=/private/etc/hosts
fi

API_HOSTS_ENTRY="$MINIKUBE_IP $INGRESS_HOST"
if grep -Fq "$INGRESS_HOST" $HOSTS_PATH > /dev/null
then
    if [ $HOST_OS = "darwin" ]
    then
        sudo sed -i '' "s/^.*$INGRESS_HOST/$API_HOSTS_ENTRY/" $HOSTS_PATH
    else
        sudo sed -i "s/^.*$INGRESS_HOST\b.*$/$API_HOSTS_ENTRY/" $HOSTS_PATH
    fi

    echo "Updated $INGRESS_HOST hosts entry"
else
    echo "$API_HOSTS_ENTRY" | sudo tee -a $HOSTS_PATH
    echo "Added $INGRESS_HOST entry"
fi

