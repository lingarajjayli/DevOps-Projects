#!/bin/bash
# ================================================================================
# S3 File Deletion Script
# ================================================================================
# This script deletes all files from the S3 bucket
# WARNING: This action cannot be undone!
# ================================================================================

echo ""
echo "=============================================================================="
echo "              S3 File Deletion Script"
echo "=============================================================================="
echo ""
echo "Bucket: nextwork-website-project-aviatorarray"
echo ""
echo "=============================================================================="
echo ""

# Function to list files before deletion
list_files() {
  echo ""
  echo "Current files in bucket:"
  aws s3 ls s3://nextwork-website-project-aviatorarray/
  echo ""
}

# Function to delete all files
delete_all_files() {
  echo ""
  echo "Step 1: Deleting all files from bucket..."
  aws s3 rm s3://nextwork-website-project-aviatorarray/* --recursive --force
  echo ""
  echo "Step 2: Verifying bucket is empty..."
  aws s3 ls s3://nextwork-website-project-aviatorarray/ || echo "Bucket is empty"
  echo ""
}

# Function to delete specific files
delete_files() {
  local files="$1"
  echo ""
  echo "Step 1: Deleting specific files: $files..."
  aws s3 rm s3://nextwork-website-project-aviatorarray/"$files"
  echo ""
}

# Function to delete bucket (after files are deleted)
delete_bucket() {
  echo ""
  echo "Step 3: Deleting bucket..."
  aws s3 rb s3://nextwork-website-project-aviatorarray --force
  echo ""
  echo "Bucket deleted successfully!"
}

# Main script logic
echo "Available Options:"
echo "  1. Delete all files: ./002-S3-delete.sh --delete-all"
echo "  2. Delete specific files: ./002-S3-delete.sh --delete-files file1,file2,file3"
echo "  3. Delete bucket: ./002-S3-delete.sh --delete-bucket"
echo ""

# Check for command line arguments
case "${1:-delete-all}" in
  --delete-all)
    list_files
    if [[ $(readlink -f /dev/tty) == "/dev/tty" ]]; then
      read -p "Are you sure you want to delete all files? (yes/no): " -n 1 -r
      echo ""
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        delete_all_files
      else
        echo "Aborted by user."
      fi
    else
      delete_all_files
    fi
    ;;
  --delete-files)
    files="$2"
    if [ -n "$files" ]; then
      delete_files "$files"
    else
      echo "Error: Please specify files to delete"
    fi
    ;;
  --delete-bucket)
    echo ""
    echo "WARNING: This will delete the bucket and all files!"
    read -p "Are you sure? (yes/no): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      delete_all_files
      delete_bucket
    else
      echo "Aborted by user."
    fi
    ;;
  *)
    list_files
    if [[ $(readlink -f /dev/tty) == "/dev/tty" ]]; then
      read -p "Are you sure you want to delete all files? (yes/no): " -n 1 -r
      echo ""
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        delete_all_files
      else
        echo "Aborted by user."
      fi
    else
      delete_all_files
    fi
    ;;
esac

echo ""
echo "=============================================================================="
echo "           Deletion operation completed!"
echo "=============================================================================="
echo ""
