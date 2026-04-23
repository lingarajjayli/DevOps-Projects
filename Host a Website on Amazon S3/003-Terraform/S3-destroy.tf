# ================================================================================
# S3 Bucket Destroy Script (Direct AWS CLI)
# This script removes the S3 bucket and all associated resources
# ================================================================================

# ================================================================================
# IMPORTANT: Run in this order!
# ================================================================================

# Step 1: List all objects in bucket (optional - to see what will be deleted)
# aws s3 ls s3://nextwork-website-project-aviatorarray/

# Step 2: Delete all objects (empty the bucket)
aws s3 rm s3://nextwork-website-project-aviatorarray/* --recursive --force

# Step 3: Delete the bucket and its policy
aws s3 rb s3://nextwork-website-project-aviatorarray --delete-bucket-policy --force

# ================================================================================
# Alternative: Delete in separate commands for debugging
# ================================================================================

# If you want to verify each step:

# Delete objects first
# aws s3 rm s3://nextwork-website-project-aviatorarray/* --recursive --force

# Then delete the bucket (without policy flag to check first)
# aws s3 rb s3://nextwork-website-project-aviatorarray --force

# Or with policy deletion flag
# aws s3 rb s3://nextwork-website-project-aviatorarray --delete-bucket-policy --force
