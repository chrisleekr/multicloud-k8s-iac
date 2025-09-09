#!/bin/bash
# This script is to assume the bootstrap role and set the AWS temporary credentials in the current shell session.
# How to run:
# ./aws-login.sh <account_id> <profile>

# Exit on error
set -e

ACCOUNT_ID=$1

echo "Checking current identity..."
if ! aws sts get-caller-identity --no-cli-pager; then
  echo "Error: Failed to get caller identity. Please check your AWS credentials."
  exit 1
fi

echo "Assuming bootstrap role..."
# Capture the assume-role response directly
CREDENTIALS=$(
  aws sts assume-role \
    --role-arn "arn:aws:iam::${ACCOUNT_ID}:role/bootstrap-role" \
    --role-session-name bootstrap-role \
    --output json \
    --no-cli-pager
)

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
  echo "Error: Failed to assume bootstrap role"
  exit 1
fi

# Extract and export the credentials
TEMP_ACCESS_KEY=$(echo "$CREDENTIALS" | jq -r '.Credentials.AccessKeyId')
TEMP_SECRET_KEY=$(echo "$CREDENTIALS" | jq -r '.Credentials.SecretAccessKey')
TEMP_SESSION_TOKEN=$(echo "$CREDENTIALS" | jq -r '.Credentials.SessionToken')

export AWS_ACCESS_KEY_ID="$TEMP_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$TEMP_SECRET_KEY"
export AWS_SESSION_TOKEN="$TEMP_SESSION_TOKEN"

echo "Check assumed identity..."
aws sts get-caller-identity --no-cli-pager

echo "Successfully assumed bootstrap role and exported credentials"
