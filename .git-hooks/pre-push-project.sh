#!/bin/bash
# Pre-push hook for project folders validation

PROJECTS=(
    "DevOps Project-01/Java-Login-App"
    "DevOps Project-02"
    "Host a Website on Amazon S3"
)

echo "📂 Validating project folders. .."

# Validate each project folder
for project in "${PROJECTS[@]}"; do
    if [ -d "$project" ]; then
        echo "✅ Found: $project"
    else
        echo "⚠️  Missing: $project"
    fi
done

echo "✅ Pre-push validation complete"
