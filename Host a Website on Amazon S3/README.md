# AWS S3 Static Website Hosting Guide

## 📚 Quick Start for Learners

This guide teaches you how to create and manage an S3 bucket for hosting static websites using three methods: **AWS Console**, **AWS CLI**, and **Terraform**.

---

## 🎯 Bucket Name
```
nextwork-website-project-aviatorarray
```

## 📍 Region
```
ap-south-1 (Mumbai)
```

## 🌐 Website URL
```
http://nextwork-website-project-aviatorarray.s3-website-ap-south-1.amazonaws.com
```

---

## 📖 Table of Contents

1. [AWS Console Method](#aws-console-method)
2. [AWS CLI Method](#aws-cli-method)
3. [Terraform Method](#terraform-method)
4. [Verify Your Website](#verify-your-website)
5. [Destroy Resources](#destroy-resources)
6. [Common Issues & Solutions](#common-issues--solutions)

---

## 🖥️ AWS Console Method

### Step 1: Sign in to AWS Console
1. Go to [AWS Management Console](https://console.aws.amazon.com/)
2. Sign in with your AWS credentials

### Step 2: Create S3 Bucket
1. Search for "S3" in services
2. Click **Create bucket**
3. Fill in details:
   - **Bucket name**: `nextwork-website-project-aviatorarray`
   - **Region**: `ap-south-1`
   - **Object ownership**: AWS account owner

### Step 3: Configure Permissions
1. **Block public access?** → **No**
2. **Next** → **Next**

### Step 4: Enable Static Website Hosting
1. **Static website hosting** → **Yes, I want to enable**
2. **Index document**: `01-index.html`
3. **Error document**: `06-error.html`
4. **Redirect to HTTPS** → **No** (or use CloudFront URL)

### Step 5: Configure ACL
1. **Grant object download permission to all users**
2. Click **Next**

### Step 6: Create Bucket
1. Click **Create bucket**

### Step 7: Add Bucket Policy
1. Go to **Permissions** tab
2. Click **Edit** under **Bucket policy**
3. Paste this policy:
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
4. Click **Save changes**

### Step 8: Upload Files
1. Drag and drop your files (index.html, CSS, JS, images)
2. Or use **Upload** button

### Step 9: Get Website URL
1. Go to **Properties** tab
2. Find **Static website hosting**
3. Copy the **Website URL**

---

## 🖥️ AWS CLI Method

### Step 1: Configure AWS CLI
```bash
aws configure
```
- **AWS Access Key ID**
- **AWS Secret Access Key**
- **Default region name**: `ap-south-1`
- **Output format**: `json`

### Step 2: Create Bucket
```bash
aws s3 mb s3://nextwork-website-project-aviatorarray --region ap-south-1
```

### Step 3: Enable Static Website Hosting
```bash
aws s3api put-bucket-website-configuration \
  --bucket nextwork-website-project-aviatorarray \
  --website-configuration '{
    "IndexDocument": {"Suffix": "01-index.html"},
    "ErrorDocument": {"Key": "06-error.html"},
    "RoutingRules": []
  }'
```

### Step 4: Enable Public Read Access
```bash
# Option 1: Using bucket policy
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

# Option 2: Using ACL (simpler)
aws s3api put-bucket-acl \
  --bucket nextwork-website-project-aviatorarray \
  --acl public-read
```

### Step 5: Upload Files
```bash
aws s3 sync ./website-files/ s3://nextwork-website-project-aviatorarray/
```

### Step 6: Verify Website
```bash
aws s3 get-bucket-website-configuration \
  --bucket nextwork-website-project-aviatorarray
```

### Step 7: Test in Browser
```bash
echo "http://nextwork-website-project-aviatorarray.s3-website-ap-south-1.amazonaws.com"
```

---

## 🧪 Terraform Method

### Step 1: Install Terraform
1. Download from [terraform.io](https://www.terraform.io/downloads)
2. Install and add to PATH
3. Verify: `terraform version`

### Step 2: Configure AWS Provider
```bash
aws configure
# or use environment variables
export AWS_ACCESS_KEY_ID=your_key
export AWS_SECRET_ACCESS_KEY=your_secret
export AWS_DEFAULT_REGION=ap-south-1
```

### Step 3: Create main.tf
(See `main.tf` in this directory)

### Step 4: Create terraform.tfvars
(See `terraform.tfvars` in this directory)

### Step 5: Initialize Terraform
```bash
cd "D:/DevOps-Projects/Host a Website on Amazon S3"
terraform init
```

### Step 6: Review Plan
```bash
terraform plan
```

### Step 7: Apply Changes
```bash
terraform apply -auto-approve
```

### Step 8: Upload Files
```bash
aws s3 sync ./website-files/ s3://nextwork-website-project-aviatorarray/
```

---

## ✅ Verify Your Website

### Check Bucket Configuration
```bash
aws s3 get-bucket-website-configuration \
  --bucket nextwork-website-project-aviatorarray
```

Expected output:
```json
{
  "ErrorDocument": {
    "Key": "06-error.html"
  },
  "IndexDocument": {
    "Suffix": "01-index.html"
  }
}
```

### Open in Browser
```
http://nextwork-website-project-aviatorarray.s3-website-ap-south-1.amazonaws.com
```

### Check Files in Bucket
```bash
aws s3 ls s3://nextwork-website-project-aviatorarray/
```

---

## 💥 Destroy Resources

### Option 1: AWS Console
1. Go to S3 Console
2. Select your bucket
3. Click **Delete**
4. Confirm deletion

### Option 2: AWS CLI
```bash
# Delete all files first
aws s3 rm s3://nextwork-website-project-aviatorarray/* --recursive --force

# Delete the bucket
aws s3 rb s3://nextwork-website-project-aviatorarray --force
```

### Option 3: Terraform
```bash
terraform destroy -auto-approve
```

---

## 🐛 Common Issues & Solutions

### Issue: 403 Forbidden Error
**Cause**: Public read access not enabled  
**Solution**: Add bucket policy or set ACL to `public-read`

### Issue: Bucket Already Exists
**Cause**: Bucket name must be unique globally  
**Solution**: Add a unique suffix (e.g., `--bucket-name your-bucket-name-123`)

### Issue: Permission Denied
**Cause**: AWS CLI not configured or wrong credentials  
**Solution**: Run `aws configure` again with correct credentials

### Issue: Files Not Appearing on Website
**Cause**: Index document not set correctly  
**Solution**: Set `IndexDocument` suffix to `index.html` in bucket settings

### Issue: Terraform Apply Fails
**Cause**: Provider not initialized  
**Solution**: Run `terraform init` before `terraform apply`

### Issue: Bucket Policy Syntax Error
**Cause**: JSON formatting issues  
**Solution**: Use proper JSON formatting (check with [jsonlint.com](https://jsonlint.com/))

---

## 📝 File Structure

```
Host a Website on Amazon S3/
├── main.tf                    # Terraform create script
├── destroy.tf                 # Terraform destroy script
├── terraform.tfvars           # Terraform variables
├── SETUP-GUIDE.md             # Detailed guide
├── README.md                  # This file
├── shell/
│   ├── console/               # Console creation steps
│   ├── cli/                   # AWS CLI commands
│   │   ├── create-bucket.sh   # Create bucket via CLI
│   │   ├── upload-files.sh    # Upload website files
│   │   ├── destroy-bucket.sh  # Delete bucket via CLI
│   │   ├── verify-bucket.sh   # Verify bucket config
│   │   ├── make-website-public.sh
│   │   ├── make-website-priv.sh
│   │   ├── delete-objects.sh  # Delete all files
│   │   ├── get-bucket-info.sh # Get bucket info
│   │   └── add-tags.sh        # Add bucket tags
│   └── terraform/             # Terraform scripts
│       ├── create-bucket.sh   # Terraform create
│       └── destroy-bucket.sh  # Terraform destroy
```

---

## 🖥️ Shell Scripts Quick Reference

### CLI Scripts (Run in Terminal)
```bash
# Create bucket
shell/cli/create-bucket.sh

# Upload files
shell/cli/upload-files.sh

# Verify bucket
shell/cli/verify-bucket.sh

# Destroy bucket
shell/cli/destroy-bucket.sh

# Make website public
shell/cli/make-website-public.sh

# Make website private
shell/cli/make-website-priv.sh
```

### Terraform Scripts
```bash
# Create with Terraform
shell/terraform/create-bucket.sh

# Destroy with Terraform
shell/terraform/destroy-bucket.sh
```

---

## 🔒 Security Best Practices

1. **Never share AWS credentials** - Use IAM roles or environment variables
2. **Enable MFA** on your AWS account
3. **Use IAM policies** with least privilege
4. **Encrypt sensitive data** using S3 encryption
5. **Enable versioning** for important files

---

## 📞 Need Help?

- AWS Documentation: [https://docs.aws.amazon.com/](https://docs.aws.amazon.com/)
- AWS Support: [https://support.aws.amazon.com/](https://support.aws.amazon.com/)
- Terraform Docs: [https://www.terraform.io/docs](https://www.terraform.io/docs)

---

## 🎉 Congratulations!

You now have a fully functional static website hosted on Amazon S3!

Keep learning:
- [AWS Lambda](https://aws.amazon.com/lambda/)
- [CloudFront](https://aws.amazon.com/cloudfront/)
- [DynamoDB](https://aws.amazon.com/dynamodb/)
- [RDS](https://aws.amazon.com/rds/)

---

**Last Updated**: 2024
**Region**: ap-south-1 (Mumbai)
**Bucket**: nextwork-website-project-aviatorarray
