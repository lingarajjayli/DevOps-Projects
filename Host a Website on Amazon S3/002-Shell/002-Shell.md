# AWS S3 Static Website Hosting - Shell Scripts Guide

## 📚 Overview

This folder contains shell scripts for automating AWS S3 operations via AWS CLI.

---

## 📁 Script Reference

| Script | Description |
|---|---|
| `002-S3-creation.sh` | Create S3 bucket and configure website hosting |
| `002-S3-policy.sh` | Add or modify bucket policies |
| `002-S3-upload.sh` | Upload files to S3 bucket |
| `002-S3-delete.sh` | Delete all objects from bucket |
| `002-S3-verify.sh` | Verify bucket configuration |
| `002-S3-destroy.sh` | Destroy bucket and delete all files |
| `002-S3-tags.sh` | Add tags to S3 bucket |
| `002-S3-info.sh` | Get bucket information |

---

## 🚀 Quick Start

### Prerequisites
```bash
# Install AWS CLI
pip install awscli

# Configure AWS credentials
aws configure
# AWS Access Key ID
# AWS Secret Access Key
# Default region (ap-south-1)
# Output format (json)
```

---

## 📄 Script Usage

### Create S3 Bucket
```bash
./002-S3-creation.sh
```

### Add Bucket Policy
```bash
./002-S3-policy.sh
```

### Upload Files
```bash
./002-S3-upload.sh
```

### Verify Bucket
```bash
./002-S3-verify.sh
```

### Destroy Bucket
```bash
./002-S3-destroy.sh
```

---

## 📋 Available Scripts

### 002-S3-creation.sh
Creates the S3 bucket with website hosting enabled.

```bash
# Create bucket
./002-S3-creation.sh

# Output:
# Bucket created successfully!
# Website URL: http://nextwork-website-project-aviatorarray.s3-website-ap-south-1.amazonaws.com
```

### 002-S3-policy.sh
Adds or modifies bucket policies.

```bash
# Add public read policy
./002-S3-policy.sh

# Or specify a custom policy
./002-S3-policy.sh --policy-file custom-policy.json
```

### 002-S3-upload.sh
Uploads website files to S3.

```bash
# Upload all files
./002-S3-upload.sh ./website-files/

# Or use aws sync directly
aws s3 sync ./website-files/ s3://nextwork-website-project-aviatorarray/
```

### 002-S3-delete.sh
Deletes all objects from the bucket.

```bash
# Delete all files
./002-S3-delete.sh

# Or directly
aws s3 rm s3://nextwork-website-project-aviatorarray/* --recursive --force
```

### 002-S3-verify.sh
Verifies bucket configuration.

```bash
./002-S3-verify.sh

# Output:
# Index Document: 01-index.html
# Error Document: 06-error.html
# Public Access: Enabled
```

### 002-S3-destroy.sh
Destroys the entire bucket and all files.

```bash
./002-S3-destroy.sh

# WARNING: This will permanently delete the bucket!
```

### 002-S3-tags.sh
Adds tags to the S3 bucket.

```bash
./002-S3-tags.sh --key Environment --value Production
```

### 002-S3-info.sh
Gets detailed information about the bucket.

```bash
./002-S3-info.sh

# Output:
# Location: ap-south-1
# Policy: {bucket policy}
# Tags: {bucket tags}
```

---

## 🔧 Making Your Own Scripts

### Create a new script:
```bash
#!/bin/bash
# My Custom Script

# Your script content here
echo "My script is running!"
```

### Make executable:
```bash
chmod +x my-script.sh
./my-script.sh
```

---

## 📝 Bash Script Guidelines

1. **Start with shebang**: `#!/bin/bash`
2. **Use comments**: Explain what each section does
3. **Handle errors**: Use `set -e` or check exit codes
4. **Make executable**: `chmod +x script.sh`
5. **Test in terminal**: Run scripts to verify behavior

---

## 🐛 Common Issues

### "No such file or directory"
**Fix**: Make script executable: `chmod +x script.sh`

### "Permission denied"
**Fix**: Run script with sudo: `sudo ./script.sh`

### "Command not found"
**Fix**: Install AWS CLI: `pip install awscli`

### "Bucket not found"
**Fix**: Check bucket name spelling and region

---

## 📞 Need Help?

- AWS Documentation: [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/)
- AWS S3: [S3 Documentation](https://docs.aws.amazon.com/AmazonS3/latest/)

---

**Last Updated**: 2024  
**Region**: ap-south-1  
**Bucket**: nextwork-website-project-aviatorarray
