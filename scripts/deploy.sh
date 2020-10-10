#!/bin/bash

set -xe

DIR="$(dirname "$0")"

pushd "$DIR/../terraform"

terraform init
terraform apply -auto-approve
