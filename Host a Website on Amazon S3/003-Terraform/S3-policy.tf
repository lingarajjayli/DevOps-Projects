# ================================================================================
# S3 Bucket Policy Configuration
# ================================================================================
# This file contains the bucket policy for public read access
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
# Alternative: Private-only Bucket Policy (for sensitive data)
# Uncomment to use instead of the above policy:
# ================================================================================

# resource "aws_s3_bucket_policy" "private_access" {
#   bucket = aws_s3_bucket.website.bucket
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid = "DenyPublicAccess"
#         Effect = "Deny"
#         Principal = "*"
#         Action = "s3:GetObject"
#         Resource = "${aws_s3_bucket.website.arn}/*"
#       }
#     ]
#   })
# }

# ================================================================================
# Public Access Block Settings
# ================================================================================

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.bucket

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}
