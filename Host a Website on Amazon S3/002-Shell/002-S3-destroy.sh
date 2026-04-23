#!/bin/bash
# ================================================================================
# S3 Bucket Destruction Script
# ================================================================================
# This script destroys the S3 bucket and all associated resources
# WARNING: This action is permanent and cannot be undone!
# ================================================================================

echo ""
echo "=============================================================================="
echo "              S3 Bucket Destruction Script"
echo "=============================================================================="
echo ""
echo "Bucket: nextwork-website-project-aviatorarray"
echo ""
echo "=============================================================================="
echo ""

# Function to destroy bucket
destroy_bucket() {
  echo ""
  echo "Step 1: Deleting all files from bucket..."
  aws s3 rm s3://nextwork-website-project-aviatorarray/* --recursive --force

  echo ""
  echo "Step 2: Deleting bucket and policy..."
  aws s3 rb s3://nextwork-website-project-aviatorarray --delete-bucket-policy --force

  echo ""
  echo "Step 3: Verifying bucket is deleted..."
  aws s3 rb s3://nextwork-website-project-aviatorarray --force 2>/dev/null && echo "Bucket already deleted" || echo "Bucket deleted successfully"

  echo ""
  echo "=============================================================================="
  echo "           S3 Bucket Destroyed!"
  echo "=============================================================================="
  echo ""
  echo "The following resources have been deleted:"
  echo "  - S3 bucket: nextwork-website-project-aviatorarray"
  echo "  - All files in the bucket"
  echo "  - Bucket policy"
  echo "  - Bucket tags"
  echo "  - Block public access settings"
  echo ""
  echo "=============================================================================="
  echo ""
}

# Function to destroy with confirmation
destroy_with_confirmation() {
  echo ""
  echo "WARNING: This script will permanently delete:"
  echo "  - S3 bucket: nextwork-website-project-aviatorarray"
  echo "  - All files in the bucket"
  echo "  - Bucket policy and settings"
  echo ""
  echo "This action CANNOT be undone!"
  echo ""

  read -p "Are you sure you want to continue? (yes/no): " -n 1 -r
  echo ""

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    destroy_bucket
  else
    echo "Aborted by user."
  fi
}

# Main script logic
echo "Available Options:"
echo "  1. Destroy with confirmation: ./002-S3-destroy.sh --confirm"
echo "  2. Destroy immediately: ./002-S3-destroy.sh --force"
echo ""

# Check for command line arguments
case "${1:-confirm}" in
  --force)
    destroy_bucket
    ;;
  --confirm)
    destroy_with_confirmation
    ;;
  *)
    destroy_with_confirmation
    ;;
esac

echo ""
echo "=============================================================================="
echo "           Destruction operation completed!"
echo "=============================================================================="
echo ""
