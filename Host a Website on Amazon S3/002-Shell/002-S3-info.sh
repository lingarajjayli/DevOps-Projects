#!/bin/bash
# ================================================================================
# S3 Bucket Information Script
# ================================================================================
# This script displays comprehensive information about the S3 bucket
# ================================================================================

echo ""
echo "=============================================================================="
echo "              S3 Bucket Information"
echo "=============================================================================="
echo ""
echo "Bucket: nextwork-website-project-aviatorarray"
echo ""
echo "=============================================================================="
echo ""

# Step 1: Bucket Location
echo "Step 1: Bucket Location..."
echo "  Region: ap-south-1 (Mumbai)"
echo ""

# Step 2: Bucket Policy
echo "Step 2: Bucket Policy..."
aws s3 get-bucket-policy \
  --bucket nextwork-website-project-aviatorarray 2>/dev/null || echo "  No policy found"
echo ""

# Step 3: Bucket ACL
echo "Step 3: Bucket ACL..."
aws s3 get-bucket-acl \
  --bucket nextwork-website-project-aviatorarray 2>/dev/null || echo "  No ACL found"
echo ""

# Step 4: Bucket Tags
echo "Step 4: Bucket Tags..."
aws s3api get-bucket-tagging \
  --bucket nextwork-website-project-aviatorarray 2>/dev/null || echo "  No tags found"
echo ""

# Step 5: Bucket Versioning
echo "Step 5: Bucket Versioning..."
aws s3api get-bucket-versioning \
  --bucket nextwork-website-project-aviatorarray 2>/dev/null || echo "  Versioning not enabled"
echo ""

# Step 6: Bucket Lifecycle
echo "Step 6: Bucket Lifecycle Rules..."
aws s3api get-bucket-lifecycle-configuration \
  --bucket nextwork-website-project-aviatorarray 2>/dev/null || echo "  No lifecycle rules found"
echo ""

# Step 7: Bucket CORS
echo "Step 7: Bucket CORS Configuration..."
aws s3api get-bucket-cors-configuration \
  --bucket nextwork-website-project-aviatorarray 2>/dev/null || echo "  No CORS configuration found"
echo ""

# Step 8: Bucket Website Configuration
echo "Step 8: Bucket Website Configuration..."
aws s3 get-bucket-website-configuration \
  --bucket nextwork-website-project-aviatorarray

echo ""

# Step 9: Public Access Block
echo "Step 9: Public Access Block Settings..."
aws s3 get-public-access-block-configuration \
  --bucket nextwork-website-project-aviatorarray

echo ""

# Step 10: Files in Bucket
echo "Step 10: Files in Bucket..."
aws s3 ls s3://nextwork-website-project-aviatorarray/

echo ""

# Step 11: Bucket Metadata
echo "Step 11: Bucket Metadata..."
aws s3api get-bucket-location \
  --bucket nextwork-website-project-aviatorarray
echo ""

echo "=============================================================================="
echo "           Information complete!"
echo "=============================================================================="
echo ""
