#!/bin/bash
# ================================================================================
# S3 Bucket Tagging Script
# ================================================================================
# This script adds or removes tags from the S3 bucket
# ================================================================================

echo ""
echo "=============================================================================="
echo "              S3 Bucket Tagging Script"
echo "=============================================================================="
echo ""
echo "Bucket: nextwork-website-project-aviatorarray"
echo ""
echo "=============================================================================="
echo ""

# Function to add tags
add_tags() {
  local key="$1"
  local value="$2"
  echo ""
  echo "Step 1: Adding tag $key=$value..."
  aws s3api put-bucket-tagging \
    --bucket nextwork-website-project-aviatorarray \
    --tagging "$(cat <<EOF
{
  "TagSet": [
    {
      "Key": "$key",
      "Value": "$value"
    }
  ]
}
EOF
)"
}

# Function to list tags
list_tags() {
  echo ""
  echo "Step 1: Listing current tags..."
  aws s3api get-bucket-tagging \
    --bucket nextwork-website-project-aviatorarray || echo "No tags found"
}

# Function to remove all tags
remove_all_tags() {
  echo ""
  echo "Step 1: Removing all tags..."
  aws s3api delete-bucket-tagging \
    --bucket nextwork-website-project-aviatorarray
}

# Function to remove specific tag
remove_tag() {
  local key="$1"
  echo ""
  echo "Step 1: Removing tag $key..."
  # Note: AWS requires you to specify all remaining tags when updating
  list_tags
}

# Function to display default tags
display_default_tags() {
  echo ""
  echo "Common tags to add:"
  echo "  Environment: Production/Development/Staging"
  echo "  Project: NextWork-Website"
  echo "  Owner: DevOps Team"
  echo "  CostCenter: Web-Hosting"
  echo "  Application: Static-Website"
}

# Main script logic
echo "Available Options:"
echo "  1. Add a single tag: ./002-S3-tags.sh --add <key> <value>"
echo "  2. Add multiple tags: ./002-S3-tags.sh --add-all <key1 name="value1,key2=value2">"
echo "  3. List tags: ./002-S3-tags.sh --list"
echo "  4. Remove all tags: ./002-S3-tags.sh --remove-all"
echo "  5. Show default tags: ./002-S3-tags.sh --help"
echo ""

# Check for command line arguments
case "${1:-help}" in
  --add)
    key="${2:-Environment}"
    value="${3:-Production}"
    add_tags "$key" "$value"
    ;;
  --add-all)
    IFS=',' read -ra TAGS <<< "${2:-}"
    for TAG in "${TAGS[@]}"; do
      key="${TAG%%=*}"
      value="${TAG#*=}"
      add_tags "$key" "$value"
    done
    ;;
  --list)
    list_tags
    ;;
  --remove-all)
    read -p "Are you sure you want to remove all tags? (yes/no): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      remove_all_tags
    else
      echo "Aborted by user."
    fi
    ;;
  --help)
    display_default_tags
    ;;
  *)
    echo "Unknown option: $1"
    display_default_tags
    ;;
esac

echo ""
echo "=============================================================================="
echo "           Tagging operation completed!"
echo "=============================================================================="
echo ""
