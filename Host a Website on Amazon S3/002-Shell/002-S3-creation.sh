#!/bin/bash
# ================================================================================
# S3 Bucket Creation Script
# ================================================================================
# This script creates an S3 bucket for static website hosting
# Region: ap-south-1 (Mumbai)
# ================================================================================

echo ""
echo "=============================================================================="
echo "              AWS S3 Bucket Creation Script"
echo "=============================================================================="
echo ""
echo "Creating S3 bucket: nextwork-website-project-aviatorarray"
echo "Region: ap-south-1 (Mumbai)"
echo ""
echo "=============================================================================="
echo ""

# Step 1: Create the bucket
echo "Step 1: Creating S3 bucket..."
aws s3 mb s3://nextwork-website-project-aviatorarray --region ap-south-1

echo ""
echo "Step 2: Enabling static website hosting..."
aws s3api put-bucket-website-configuration \
  --bucket nextwork-website-project-aviatorarray \
  --website-configuration '{
    "IndexDocument": {"Suffix": "01-index.html"},
    "ErrorDocument": {"Key": "06-error.html"},
    "RoutingRules": []
  }'

echo ""
echo "Step 3: Adding bucket policy for public read access..."
aws s3api put-bucket-policy \
  --bucket nextwork-website-project-aviatorarray \
  --policy '{
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

echo ""
echo "Step 4: Disabling block public access..."
aws s3api put-public-access-block \
  --bucket nextwork-website-project-aviatorarray \
  --public-access-block-configuration 'BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false'

echo ""
echo "Step 5: Verifying bucket configuration..."
aws s3 get-bucket-website-configuration \
  --bucket nextwork-website-project-aviatorarray

echo ""
echo "=============================================================================="
echo "           S3 Bucket Created Successfully!"
echo "=============================================================================="
echo ""
echo "Website URL: http://nextwork-website-project-aviatorarray.s3-website-ap-south-1.amazonaws.com"
echo ""
echo "=============================================================================="
echo ""
