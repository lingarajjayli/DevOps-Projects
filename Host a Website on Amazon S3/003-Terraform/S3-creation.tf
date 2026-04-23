# ================================================================================
# S3 Bucket Terraform Creation Script
# This script creates an S3 bucket for static website hosting in ap-south-1
# ================================================================================

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

# ================================================================================
# S3 Bucket for Static Website
# ================================================================================

resource "aws_s3_bucket" "website" {
  bucket = "nextwork-website-project-aviatorarray"

  # Enable versioning
  versioning {
    enabled = false
  }
}

# ================================================================================
# S3 Bucket Policy for public read access
# ================================================================================

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

# ================================================================================
# Block Public Access Settings
# ================================================================================

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.bucket

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# ================================================================================
# Output the website endpoint URL
# ================================================================================

output "website_endpoint" {
  value = aws_s3_bucket.website.website_endpoint
}

# ================================================================================
# Variables file (create this separately)
# ================================================================================

# Copy terraform.tfvars to this location or create new:
# region = "ap-south-1"
# bucket_name = "nextwork-website-project-aviatorarray"
# force_destroy = true
