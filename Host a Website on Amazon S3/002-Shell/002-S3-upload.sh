#!/bin/bash
# ================================================================================
# S3 File Upload Script
# ================================================================================
# This script uploads files to the S3 bucket
# ================================================================================

echo ""
echo "=============================================================================="
echo "              S3 File Upload Script"
echo "=============================================================================="
echo ""
echo "Bucket: nextwork-website-project-aviatorarray"
echo ""
echo "=============================================================================="
echo ""

# Source directory
SRC_DIR="${1:-./website-files}"

# Step 1: Check if source directory exists
echo "Step 1: Checking source directory: $SRC_DIR"
if [ ! -d "$SRC_DIR" ]; then
  echo "Error: Source directory '$SRC_DIR' does not exist!"
  echo "Creating source directory with sample files..."
  mkdir -p "$SRC_DIR"
  echo "01-index.html" > "$SRC_DIR/01-index.html"
  echo "06-error.html" > "$SRC_DIR/06-error.html"
fi

# Step 2: List files to upload
echo ""
echo "Step 2: Files to upload:"
ls -la "$SRC_DIR"

# Step 3: Sync files to S3
echo ""
echo "Step 3: Uploading files to S3..."
aws s3 sync "$SRC_DIR" s3://nextwork-website-project-aviatorarray/

# Step 4: Verify upload
echo ""
echo "Step 4: Verifying uploaded files..."
aws s3 ls s3://nextwork-website-project-aviatorarray/

# Step 5: Set permissions (optional)
echo ""
echo "Step 5: Setting public read permission on files..."
aws s3api put-object-acl \
  --bucket nextwork-website-project-aviatorarray \
  --acl public-read \
  --key "/*"

echo ""
echo "=============================================================================="
echo "           Files uploaded successfully!"
echo "=============================================================================="
echo ""
echo "Your website is now live at:"
echo "http://nextwork-website-project-aviatorarray.s3-website-ap-south-1.amazonaws.com"
echo ""
echo "=============================================================================="
echo ""
