#!/bin/bash
# This script is to validate the infrastructure deployer role using the provided profile.
# How to run:
# ./cloudformation-validate.sh <environment> <region>

# Exit on error
set -e

# Get current shell file's directory
SCRIPT_DIR=$(dirname "$0")

ENVIRONMENT=${1:-dev}

# Map environment to account ID - In here, we are using the same account ID for all environments. But it should be different per environment. Rather than passing the account ID, we can pass the environment name to the script to avoid any mistake.
case "$ENVIRONMENT" in
"dev") ACCOUNT_ID="120569602166" ;;
"staging") ACCOUNT_ID="120569602166" ;;
"prod") ACCOUNT_ID="120569602166" ;;
*) echo "Error: Environment must be one of: dev, staging, prod" && exit 1 ;;
esac

REGION=${2:-ap-southeast-2}

if [ -z "$REGION" ]; then
  echo "Error: Region is not set"
  exit 1
fi

# Execute aws-login.sh
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/aws-login.sh" "${ACCOUNT_ID}"

echo "Validating deployer stack..."

aws cloudformation validate-template \
  --region "${REGION}" \
  --no-cli-pager \
  --template-body "file://${SCRIPT_DIR}/templates/deployer.yaml"

echo "Validating terraform state stack..."

aws cloudformation validate-template \
  --region "${REGION}" \
  --no-cli-pager \
  --template-body "file://${SCRIPT_DIR}/templates/terraform-state.yaml"

echo "All stacks validated successfully"
