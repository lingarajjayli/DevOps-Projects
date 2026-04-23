#!/bin/bash
# ================================================================================
# S3 Bucket Policy Management Script
# ================================================================================
# This script manages bucket policies for S3 buckets
# ================================================================================

echo ""
echo "=============================================================================="
echo "              S3 Bucket Policy Management"
echo "=============================================================================="
echo ""
echo "Bucket: nextwork-website-project-aviatorarray"
echo ""
echo "=============================================================================="
echo ""

# Function to add bucket policy
add_policy() {
  local policy="$1"
  echo "Adding bucket policy..."
  aws s3api put-bucket-policy \
    --bucket nextwork-website-project-aviatorarray \
    --policy "$policy"
}

# Function to remove bucket policy
remove_policy() {
  echo "Removing bucket policy..."
  aws s3api delete-bucket-policy \
    --bucket nextwork-website-project-aviatorarray
}

# Function to get bucket policy
get_policy() {
  echo "Getting current bucket policy..."
  aws s3 get-bucket-policy \
    --bucket nextwork-website-project-aviatorarray
}

# Function to enable public read access
enable_public_access() {
  echo "Enabling public read access..."
  add_policy '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowPublicRead",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::nextwork-website-project-aviatorarray/*"
      }
    ]
  }'
}

# Function to disable public read access
disable_public_access() {
  echo "Disabling public read access..."
  remove_policy
}

# Main script logic
echo "Available Options:"
echo "  1. Enable public read access"
echo "  2. Disable public read access"
echo "  3. View current policy"
echo ""
echo "Or pipe a policy directly to the script:"
echo "  ./002-S3-policy.sh --add-policy 'your-policy-json'"
echo ""

# Check for command line arguments
case "${1:-enable-public}" in
  --add-policy)
    policy="$2"
    add_policy "$policy"
    ;;
  --remove-policy)
    remove_policy
    ;;
  --enable-public)
    enable_public_access
    ;;
  --disable-public)
    disable_public_access
    ;;
  --get-policy)
    get_policy
    ;;
  *)
    enable_public_access
    ;;
esac

echo ""
echo "=============================================================================="
echo "           Policy operation completed!"
echo "=============================================================================="
echo ""
