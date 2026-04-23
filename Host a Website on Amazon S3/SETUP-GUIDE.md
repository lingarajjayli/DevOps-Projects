# S3 Bucket Setup Guide

## Bucket: nextwork-website-project-aviatorarray

This guide covers three methods to create and configure an S3 bucket for hosting a static website.

---

## Method 1: AWS Console (Manual)

### Step-by-Step Instructions

#### 1. Sign in to AWS Console
- Go to [AWS Management Console](https://console.aws.amazon.com/)
- Sign in with your AWS credentials

#### 2. Navigate to S3 Service
- Search for "S3" in the AWS Services menu
- Click on **S3** to open the service

#### 3. Create a New Bucket
- Click **+ Create bucket** button
- Fill in the details:

| Field | Value |
|-------|-------|
| **Bucket name** | `nextwork-website-project-aviatorarray` (or unique name) |
| **Region** | `us-east-1` (or your preferred region) |
| **Object ownership** | AWS account owner (original owner retains ownership) |

#### 4. Configure Bucket Permissions
- Check **Block all public access?** → **No** (for website hosting)
- Click **Next**

#### 5. Configure Static Website Hosting
- Scroll down to **Static website hosting with Amazon S3** section
- Select **Yes, I want to enable static website hosting**
- Enter **Index document** → `01-index.html`
- Enter **Error document** → `06-error.html`
- Under **Redirect all requests to HTTPS**:
  - Select **No** (or enter CloudFront distribution URL if using CloudFront)

#### 6. Configure Static Website Index Document
- **Index document**: `01-index.html`
- **Error document**: `06-error.html`

### Website Files Structure

| File Number | File Name | Purpose |
|-------------|-----------|---------|
| 01 | `01-index.html` | Main homepage |
| 02 | `02-style.css` | CSS styles |
| 03 | `03-scripts.js` | JavaScript functionality |
| 04 | `04-contact.html` | Contact page |
| 05 | `05-about.html` | About page |
| 06 | `06-error.html` | 403 error page |
| 07 | `07-indexing.html` | File index |

#### 7. Configure Access
- Scroll to **Access control list (ACL)**
- Select **Grant object download permission to all users** (for public access)
- Click **Next**

#### 8. Add Tags (Optional)
- Add tags if needed (e.g., `Environment=Production`, `Project=Website`)

#### 9. Create Bucket
- Click **Create bucket**

#### 10. Configure Bucket Policy (After Creation)
```json
{
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
}
```

- Go to **Permissions** tab
- Click **Edit** under Bucket policy
- Paste the policy above
- Click **Save changes**

#### 11. Upload Files
- Drag and drop your `index.html` and other files into the bucket

#### 12. Get Website URL
- In the **Properties** tab, find **Static website hosting**
- Copy the **Website URL** (e.g., `https://nextwork-website-project-aviatorarray.s3-website-us-east-1.amazonaws.com`)

---

## Method 2: AWS CLI

### Step-by-Step Instructions

#### 1. Install and Configure AWS CLI
```bash
# Install AWS CLI (if not already installed)
# Windows: https://awscli.amazonaws.com/AWSCLIV2.msi
# Mac: brew install awscli
# Linux: curl "https://awscli.amazonaws.com/AWSCLIAPI" | sudo /bin/bash

# Configure AWS credentials
aws configure
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region name (e.g., us-east-1)
# - Output format (e.g., json)
```

#### 2. Create S3 Bucket
```bash
aws s3 mb s3://nextwork-website-project-aviatorarray --region ap-south-1
```

#### 3. Set Bucket Website Configuration
```bash
aws s3api put-bucket-website-configuration \
  --bucket nextwork-website-project-aviatorarray \
  --website-configuration '{
    "IndexDocument": {
      "Suffix": "01-index.html"
    },
    "ErrorDocument": {
      "Key": "06-error.html"
    },
    "RoutingRules": []
  }'
```

#### 4. Enable Public Access
```bash
# Allow public read access
aws s3api put-object-acl \
  --bucket nextwork-website-project-aviatorarray \
  --key index.html \
  --acl public-read

# Grant public access to all objects in bucket
aws s3api put-public-access-block \
  --bucket nextwork-website-project-aviatorarray \
  --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false

# Or set bucket policy for public read
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
```

#### 5. Upload Website Files
```bash
# Sync all numbered files to S3 (upload in order)
aws s3 sync ./website-files/ s3://nextwork-website-project-aviatorarray/

# Upload individual files in order
aws s3 cp 01-index.html s3://nextwork-website-project-aviatorarray/01-index.html
aws s3 cp 02-style.css s3://nextwork-website-project-aviatorarray/02-style.css
aws s3 cp 03-scripts.js s3://nextwork-website-project-aviatorarray/03-scripts.js
aws s3 cp 04-contact.html s3://nextwork-website-project-aviatorarray/04-contact.html
aws s3 cp 05-about.html s3://nextwork-website-project-aviatorarray/05-about.html
aws s3 cp 06-error.html s3://nextwork-website-project-aviatorarray/06-error.html
aws s3 cp 07-indexing.html s3://nextwork-website-project-aviatorarray/07-indexing.html
```

#### 6. Verify Website URL
```bash
aws s3 get-bucket-website-configuration \
  --bucket nextwork-website-project-aviatorarray
```

#### 7. Test the Website
```bash
# Open browser with the URL
echo "http://nextwork-website-project-aviatorarray.s3-website-ap-south-1.amazonaws.com"
```

---

## Method 3: Terraform

### Step-by-Step Instructions

#### 1. Prerequisites
- Install Terraform: https://www.terraform.io/downloads
- Install AWS Provider
- Configure AWS credentials (`aws configure` or environment variables)

#### 2. Create Terraform Configuration Files

#### 3. Main Terraform File (`main.tf`)

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# S3 Bucket for Static Website
resource "aws_s3_bucket" "website" {
  bucket = "nextwork-website-project-aviatorarray"
  
  # Enable versioning (optional)
  versioning {
    enabled = false
  }

  # Enable lifecycle rules (optional)
  lifecycle_rule {
    id     = "ExpireOldVersions"
    enabled = true
    status = "Enabled"
    
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

# S3 Bucket Policy for public read access
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

# Block Public Access Settings
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.bucket
  
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# CloudFront Distribution (Optional - for HTTPS)
resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.website.website_domain_name
    origin_id   = "S3-website-origin"
    origin_path = ""
    
    origin_s3_bucket_config {
      origin_access_identity = null # Not needed for direct S3 website hosting
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    }
    
    originShield {
      enabled = false
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for static website"
  
  default_root_object = "index.html"
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-website-origin"
    
    forwarded_values {
      query_string = false
      headers      = ["*"]
      cookies {
        behavior = "all"
      }
    }

    compress = true
  }

  prices_version = "Current"

  restrictions {
    geo_restriction {
      restriction_status_list = ["whiteList"]
      locations               = ["US", "CA", "GB", "DE", "FR", "JP", "AU"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = "arn:aws:acm:ap-south-1:123456789012:certificate/xxxxx" # Add your cert
    ssl_support_method             = "sni-only"
  }

  viewer_protocol_policy = "redirect-to-https"
  
  custom_error_response {
    error_code            = 403
    response_code         = 403
    response_page_path    = "/error.html"
    error_caching_min_ttl = 0
  }
}

# Create Error Page (Optional)
resource "aws_s3_object" "error_page" {
  bucket = aws_s3_bucket.website.bucket
  key    = "error.html"

  content = <<-EOT
    <!DOCTYPE html>
    <html>
    <head>
      <title>Error - ${var.error_title}</title>
      <meta http-equiv="refresh" content="0; url=${var.error_url}">
      <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background: #f5f5f5; }
        h1 { color: #333; }
        .aws-badge { background: #FF9900; color: white; padding: 10px 20px; border-radius: 5px; display: inline-block; margin: 20px 0; }
      </style>
    </head>
    <body>
      <h1>${var.error_title}</h1>
      <p>Please go to: <a href="${var.error_url}">${var.error_url}</a></p>
      <div class="aws-badge">Powered by Amazon S3</div>
    </body>
    </html>
    EOT

  content_type = "text/html"
}

# Variables file
variable "error_title" {
  description = "Title for error page"
  type        = string
  default     = "403 Forbidden"
}

variable "error_url" {
  description = "URL to redirect to on error"
  type        = string
  default     = "https://www.google.com/"
}
```

#### 4. Backend Website Files (`backend-files/`)

```bash
# Create files for deployment
mkdir -p backend-files

# Create index.html
cat > backend-files/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Static Website</title>
</head>
<body>
    <h1>Welcome to My Static Website!</h1>
    <p>This website is hosted on Amazon S3.</p>
</body>
</html>
EOF

# Create error.html
cat > backend-files/error.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
</head>
<body>
    <h1>Error!</h1>
    <p>Go to Google</p>
</body>
</html>
EOF
```

#### 5. Apply Terraform Configuration

```bash
# Initialize Terraform
terraform init

# Review the planned changes
terraform plan

# Apply the configuration
terraform apply

# After creating the S3 bucket via Terraform:
# Upload your actual files
aws s3 sync ./backend-files/ s3://nextwork-website-project-aviatorarray/

# Or use the CloudFront URL
# Replace $CF_ID with the distribution ID from terraform apply output
OPEN "https://$CF_ID.cloudfront.net"
```

#### 6. Destroy Resources (When Done)

```bash
terraform destroy
```

---

## Quick Commands Reference

### Create Bucket (CLI)
```bash
aws s3 mb s3://nextwork-website-project-aviatorarray --region ap-south-1
```

### Upload Files
```bash
aws s3 sync ./website-files/ s3://nextwork-website-project-aviatorarray/
```

### Configure Website Hosting
```bash
aws s3api put-bucket-website-configuration \
  --bucket nextwork-website-project-aviatorarray \
  --website-configuration '{
    "IndexDocument": {"Suffix": "index.html"},
    "ErrorDocument": {"Key": "error.html"}
  }'
```

### Enable Public Read Access
```bash
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
```

### Secret Mission: Stop Deletion of Files

This policy **denies everyone (including you)** from deleting objects in your bucket:

```json
{
  "Version": "2012-10-17",
  "Id": "MyBucketPolicy",
  "Statement": [
    {
      "Sid": "BucketPutDelete",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:DeleteObject",
      "Resource": "arn:aws:s3:::<bucket-name>/<object-name>"
    }
  ]
}
```

💡 **What does this policy do?**
- Using bucket policies means you can control more than just who can see/access an object
- You can manage who can delete, change, or upload new objects to your bucket
- Bucket policies give you higher-level control compared to ACLs

💡 **JSON Policy Breakdown:**

| JSON Field | Description |
|------------|-------------|
| `"Version": "2012-10-17"` | Policy language version using AWS's 2012 standard (latest version!) |
| `"Id": "MyBucketPolicy"` | ID for searching your policy in AWS Management Console |
| `"Statement"` | Section outlining all permissions (allow or deny) |
| `"Sid": "BucketPutDelete"` | Specific ID for this statement/rule |
| `"Effect": "Deny"` | Specifies that this rule will deny certain actions |
| `"Principal": "*"` | Applies to everyone, even you. No exceptions! |
| `"Action": "s3:DeleteObject"` | The action being denied—delete any object in S3 |
| `"Resource": "arn:aws:s3:::<bucket-name>/<object-name>"` | Exactly which files no one can delete |

### Full Policy Example (Allow Read + Deny Delete)

```json
{
  "Version": "2012-10-17",
  "Id": "MyBucketPolicy",
  "Statement": [
    {
      "Sid": "AllowPublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::nextwork-website-project-aviatorarray/*"
    },
    {
      "Sid": "DenyDelete",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:DeleteObject",
      "Resource": "arn:aws:s3:::nextwork-website-project-aviatorarray/*"
    }
  ]
}
```

Apply the combined policy:
```bash
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
      },
      {
        "Sid": "DenyDelete",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:DeleteObject",
        "Resource": "arn:aws:s3:::nextwork-website-project-aviatorarray/*"
      }
    ]
  }'
```

### Get Website URL
```bash
aws s3 get-bucket-website-configuration --bucket nextwork-website-project-aviatorarray
```

---

## Destroying S3 Resources

### Method 1: AWS Console
1. Go to S3 Console → Select your bucket → More → **Delete**
2. Confirm bucket deletion (bucket must be empty first)

### Method 2: AWS CLI
```bash
# Delete all objects first
aws s3 rm s3://nextwork-website-project-aviatorarray/* --recursive --force

# Delete the bucket
aws s3 rb s3://nextwork-website-project-aviatorarray --force

# Or with policy deletion
aws s3 rb s3://nextwork-website-project-aviatorarray --delete-bucket-policy --force
```

### Method 3: Terraform Destroy
```bash
# Navigate to Terraform directory
cd destroy-terraform.tf

# Initialize Terraform
terraform init

# Show what will be destroyed
terraform plan -destroy

# Apply destroy
terraform destroy -auto-approve

# Or use the dedicated destroy script
terraform apply -auto-approve
```

---

## Verification Checklist

- [ ] Bucket created successfully
- [ ] Static website hosting enabled
- [ ] Index document set to `index.html`
- [ ] Public read access configured
- [ ] Files uploaded to bucket
- [ ] Website URL verified in browser
- [ ] No 403 errors when accessing the website
