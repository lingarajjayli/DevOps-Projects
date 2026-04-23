# AWS S3 Static Website Hosting - Terraform Guide

## 📚 Overview

This guide teaches you how to create and manage S3 buckets using **Terraform** - an Infrastructure as Code (IaC) tool.

---

## 🎯 Bucket Details

| Property | Value |
|---|---|
| **Bucket Name** | `nextwork-website-project-aviatorarray` |
| **Region** | `ap-south-1` (Mumbai) |
| **Website URL** | `http://nextwork-website-project-aviatorarray.s3-website-ap-south-1.amazonaws.com` |

---

## 📋 Terraform Files Reference

| File | Description |
|---|---|
| `003-Terraform.md` | This documentation file |
| `terraform.tfvars` | Terraform variables (region, bucket name) |
| `S3-creation.tf` | Main Terraform configuration |
| `S3-policy.tf` | Bucket policy configuration |
| `S3-destroy.tf` | Terraform destroy script |

---

## 🚀 Quick Start

### Step 1: Prerequisites
```bash
# Install Terraform
# Download from: https://www.terraform.io/downloads

# Verify installation
terraform version
```

### Step 2: Configure AWS Credentials
```bash
# Option 1: Using aws configure
aws configure

# Option 2: Using environment variables
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_DEFAULT_REGION=ap-south-1
```

### Step 3: Navigate to Terraform Directory
```bash
cd "D:/DevOps-Projects/Host a Website on Amazon S3/003-Terraform"
```

### Step 4: Initialize Terraform
```bash
terraform init
```

### Step 5: Review the Plan
```bash
terraform plan
```

### Step 6: Apply the Configuration
```bash
terraform apply -auto-approve
```

### Step 7: Upload Files
```bash
aws s3 sync ./website-files/ s3://nextwork-website-project-aviatorarray/
```

---

## 📄 S3-creation.tf

This is the main Terraform configuration file that creates:

1. **S3 Bucket** with website hosting
2. **Bucket Policy** for public read access
3. **Public Access Block** settings
4. **Outputs** for bucket endpoints

### Features:
- Creates bucket in `ap-south-1` region
- Enables static website hosting
- Configures public read access
- Sets up lifecycle rules

### Commands:
```bash
# Create the bucket
terraform apply

# Destroy the bucket
terraform destroy
```

---

## 📄 terraform.tfvars

This file stores Terraform variables:

```hcl
region = "ap-south-1"
bucket_name = "nextwork-website-project-aviatorarray"
force_destroy = true
```

---

## 📄 S3-policy.tf

This file contains bucket policy configurations:

```hcl
resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.website.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowPublicRead"
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}
```

---

## 📄 S3-destroy.tf

This file contains the destroy configuration:

```bash
# Destroy the bucket
terraform destroy -auto-approve
```

---

## 🔧 Common Operations

### Create Bucket
```bash
cd 003-Terraform
terraform init
terraform apply -auto-approve
```

### Verify Creation
```bash
terraform show
```

### View Output
```bash
terraform output
```

### Destroy Bucket
```bash
terraform destroy -auto-approve
```

---

## 📝 Terraform Commands Reference

| Command | Description |
|---|---|
| `terraform init` | Initialize Terraform |
| `terraform plan` | Show what will change |
| `terraform apply` | Apply the changes |
| `terraform show` | Show resource state |
| `terraform destroy` | Destroy all resources |
| `terraform state list` | List all resources |
| `terraform console` | Open Terraform console |

---

## 📋 Output Variables

After running `terraform apply`, you'll see:

```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

website_endpoint = "http://nextwork-website-project-aviatorarray.s3-website-ap-south-1.amazonaws.com"
```

---

## 🐛 Troubleshooting

### Error: Provider not installed
```bash
terraform init
```

### Error: Bucket already exists
```bash
# Use a different bucket name or force destroy
terraform.tfvars: force_destroy = true
```

### Error: Permission denied
```bash
# Check AWS credentials
aws sts get-caller-identity
```

---

## 🔒 Security Best Practices

1. **Never commit credentials** - Use environment variables or AWS Secrets Manager
2. **Use IAM roles** instead of access keys in production
3. **Enable encryption** for sensitive data
4. **Use S3 bucket policies** for fine-grained access control
5. **Enable logging** for audit trails

---

## 📞 Need Help?

- Terraform Docs: [docs.terraform.io](https://www.terraform.io/docs)
- AWS S3 Docs: [docs.aws.amazon.com/AmazonS3/latest/](https://docs.aws.amazon.com/AmazonS3/latest/)

---

**Last Updated**: 2024  
**Region**: ap-south-1  
**Bucket**: nextwork-website-project-aviatorarray
