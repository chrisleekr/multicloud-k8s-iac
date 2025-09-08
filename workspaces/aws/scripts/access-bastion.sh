#!/bin/bash
# This script is to access the bastion host automatically by selecting the bastion host tag.

# Exit on error
set -e

REGION=${1:-ap-southeast-2}

# Get current directory of the script
SCRIPT_DIR=$(dirname "$0")

echo "Checking current identity..."
if ! aws sts get-caller-identity --no-cli-pager; then
  echo "Error: Failed to get caller identity. Please check your AWS credentials."
  exit 1
fi

# Get the bastion instance id by looking up the name `bastion-host`
BASTION_INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Bastion,Values=true" "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output text \
  --region "$REGION" \
  --no-cli-pager)

if [ -z "$BASTION_INSTANCE_ID" ]; then
  echo "Error: No bastion instance found. Please check your AWS credentials."
  exit 1
fi

echo "Bastion instance ID: $BASTION_INSTANCE_ID"

# Get the private IP address of the web servers from Terraform output
WEB_SERVER_PRIVATE_IPS=$(cd "$SCRIPT_DIR/../terraform" && terraform output -json web_server_private_ips | jq -r '.[]')

# Print the private IP addresses of the web servers
echo "Web server private IP addresses:"
echo "$WEB_SERVER_PRIVATE_IPS"

# Run ec2-instance-connect ssh to the bastion host
aws ec2-instance-connect ssh --instance-id "$BASTION_INSTANCE_ID" --region "$REGION" --no-cli-pager
