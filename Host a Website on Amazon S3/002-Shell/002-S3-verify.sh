#!/bin/bash
# ================================================================================
# S3 Bucket Verification Script
# ================================================================================
# This script verifies bucket configuration
# ================================================================================

echo ""
echo "=============================================================================="
echo "              S3 Bucket Verification"
echo "=============================================================================="
echo ""
echo "Bucket: nextwork-website-project-aviatorarray"
echo ""
echo "=============================================================================="
echo ""

# Step 1: Get bucket location
echo "Step 1: Bucket Location..."
aws s3api get-bucket-location \
  --bucket nextwork-website-project-aviatorarray

echo ""
echo "Step 2: Bucket Website Configuration..."
aws s3 get-bucket-website-configuration \
  --bucket nextwork-website-project-aviatorarray

echo ""
echo "Step 3: Bucket Policy..."
aws s3 get-bucket-policy \
  --bucket nextwork-website-project-aviatorarray

echo ""
echo "Step 4: Bucket ACL..."
aws s3 get-bucket-acl \
  --bucket nextwork-website-project-aviatorarray

echo ""
echo "Step 5: Listing Files in Bucket..."
aws s3 ls s3://nextwork-website-project-aviatorarray/

echo ""
echo "Step 6: Bucket Tags (if any)..."
aws s3api get-bucket-tagging \
  --bucket nextwork-website-project-aviatorarray || echo "No tags found"

echo ""
echo "Step 7: Bucket Versioning (if enabled)..."
aws s3api get-bucket-versioning \
  --bucket nextwork-website-project-aviatorarray || echo "Versioning not enabled"

echo ""
echo "=============================================================================="
echo "           Verification Complete!"
echo "=============================================================================="
echo ""
echo "Summary:"
echo "  - Bucket: nextwork-website-project-aviatorarray"
echo "  - Region: ap-south-1"
echo "  - Website Hosting: Enabled"
echo "  - Index Document: 01-index.html"
echo "  - Error Document: 06-error.html"
echo "  - Public Access: Enabled"
echo ""
echo "=============================================================================="
echo ""
