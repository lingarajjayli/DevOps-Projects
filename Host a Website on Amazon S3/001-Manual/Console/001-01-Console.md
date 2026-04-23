# AWS S3 Static Website Hosting - Console Method

## 📚 Quick Start Guide

This guide teaches you how to create an S3 bucket for hosting static websites using the **AWS Console**.

---

## 🎯 Bucket Details

| Property | Value |
|---|---|
| **Bucket Name** | `nextwork-website-project-aviatorarray` |
| **Region** | `ap-south-1` (Mumbai) |
| **Website URL** | `http://nextwork-website-project-aviatorarray.s3-website-ap-south-1.amazonaws.com` |

---

## 📋 Step-by-Step Console Instructions

### Step 1: Sign in to AWS Console
1. Go to [AWS Management Console](https://console.aws.amazon.com/)
2. Sign in with your AWS credentials

### Step 2: Navigate to S3
1. Search for **"S3"** in the AWS services list
2. Click on **S3** to open the S3 console

### Step 3: Create Bucket
1. Click the **"+ Create bucket"** button
2. Fill in the following details:

   | Field | Value |
   |---|---|
   | **Bucket name** | `nextwork-website-project-aviatorarray` |
   | **Region** | `ap-south-1` |
   | **Object ownership** | `AWS account owner` |

3. Click **Next**

### Step 4: Configure Permissions
1. **Block all public access?** → Select **NO**
2. Click **Next**

### Step 5: Enable Static Website Hosting
1. Select **Yes, I want to enable**
2. **Index document**: `01-index.html`
3. **Error document**: `06-error.html`
4. Click **Next**

### Step 6: Configure ACL
1. Select **Grant object download permission to all users**
2. Click **Next**

### Step 7: Create Bucket
1. Click **Create bucket**
2. Wait for the bucket to be created

### Step 8: Add Bucket Policy
1. Go to the **Permissions** tab
2. Click **Edit** under **Bucket policy**
3. Paste the following policy:

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

### Step 9: Upload Files
1. Drag and drop your website files into the bucket
2. Or click **Upload** and select files:
   - `01-index.html`
   - `02-style.css`
   - `03-scripts.js`
   - `04-contact.html`
   - `05-about.html`
   - `06-error.html`
   - `07-indexing.html`

### Step 10: Get Website URL
1. Go to the **Properties** tab
2. Find **Static website hosting**
3. Copy the **Website URL**
4. Open the URL in your browser to test

### Step 11: Verify Your Website
1. Open the website URL in your browser
2. You should see your `01-index.html` content
3. If not, check that the index document is set correctly

---

## ✅ Verification Steps

### Check Bucket Configuration
1. Go to **Properties** tab
2. Verify **Static website hosting** is enabled
3. Verify **Index document** is `01-index.html`

### Check Bucket Policy
1. Go to **Permissions** tab
2. Verify the bucket policy allows public read access

### Check Files in Bucket
1. Go to **Objects** tab
2. Verify all files are uploaded

---

## 🔄 Common Console Operations

### Make Website Public
1. Go to **Permissions** tab
2. Add bucket policy for public read access
3. Go to **Block public access** section
4. Enable public access

### Make Website Private
1. Go to **Permissions** tab
2. Remove bucket policy
3. Enable block public access

### Delete Bucket
1. Click **Delete bucket** button
2. Enter bucket name to confirm
3. Click **Delete**

---

## 📋 Quick Reference Commands

| Action | Command/Steps |
|---|---|
| Create Bucket | Console → Create bucket |
| Upload Files | Drag & drop or Upload button |
| Delete Files | Select files → Delete |
| Get Bucket URL | Properties → Static website hosting |
| Add Policy | Permissions → Edit bucket policy |
| Delete Bucket | Delete bucket button |

---

## 🐛 Troubleshooting

### 403 Forbidden Error
**Cause**: Public access not enabled  
**Fix**: Add bucket policy or enable public access

### Bucket Already Exists
**Cause**: Bucket name must be unique  
**Fix**: Use a unique bucket name with suffix

### Files Not Appearing
**Cause**: Index document not set correctly  
**Fix**: Set index document to `01-index.html`

---

## 📞 Need Help?

- AWS Documentation: [S3 Documentation](https://docs.aws.amazon.com/AmazonS3/latest/)
- AWS Support: [Support Portal](https://support.aws.amazon.com/)

---

**Last Updated**: 2024  
**Region**: ap-south-1  
**Bucket**: nextwork-website-project-aviatorarray
