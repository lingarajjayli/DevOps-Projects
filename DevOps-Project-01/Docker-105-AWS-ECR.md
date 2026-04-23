# 005 - AWS ECR (Elastic Container Registry)

**Module 2 - Part 5**  
**Topic:** Pushing and pulling containers to AWS ECR

---

## ECR Setup

### Configure AWS CLI

```bash
# Install AWS CLI if needed
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

# Configure AWS credentials
aws configure
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region name (e.g., us-east-1)
# - Output format (json)

# Verify configuration
aws sts get-caller-identity
```

### List ECR Repositories

```bash
# List ECR repositories in account
aws ecr describe-repositories

# Describe specific repository
aws ecr describe-repository \
  --repository-name myapp \
  --region us-east-1

# List images in repository
aws ecr batch-get-images \
  --repository-name myapp \
  --region us-east-1
```

---

## Login to ECR

### Login Commands

```bash
# Get ECR URL
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  123456789012.dkr.ecr.us-east-1.amazonaws.com

# Note: Login is temporary (uses auth tokens)
# Re-login after session expires

# Alternative: Use ECR auth token
aws ecr get-login-password --region us-east-1 \
  > /tmp/ecr-password.txt

docker login \
  --username AWS \
  --password-file /tmp/ecr-password.txt \
  123456789012.dkr.ecr.us-east-1.amazonaws.com
```

### ECR URL Format

```
{account}.dkr.ecr.{region}.amazonaws.com/{repository}
# Example:
123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp
```

---

## Tagging Images

### Tag for ECR

```bash
# Tag image for ECR
docker tag myapp:1.0 \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# Tag with digest
docker tag myapp:1.0 \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp@sha256:abc123

# Multiple tags
docker tag myapp:1.0 \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
docker tag myapp:1.0 \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:v1.0
```

---

## Pushing Images to ECR

### Push Commands

```bash
# Push image
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# Push multiple tags
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest

# Push with ECR helper
aws ecr push \
  --region us-east-1 \
  --repository-name myapp \
  --image-tag 1.0
```

### Batch Push Script

```bash
#!/bin/bash

# Get ECR auth
ACCOUNT="123456789012"
REGION="us-east-1"
REPO="myapp"
IMAGE="myapp"

# Login
aws ecr get-login-password --region $REGION | \
  docker login --username AWS --password-stdin \
  ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com

# Tag
docker tag ${IMAGE}:latest \
  ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:latest
docker tag ${IMAGE}:latest \
  ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:v1.0

# Push
docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:latest
docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:v1.0
```

---

## Pulling from ECR

### Pull Commands

```bash
# Pull image
docker pull 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# Pull latest
docker pull 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest

# Pull with --platform for ARM64
docker pull --platform linux/amd64 \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
```

---

## ECR Image Scanning

### Enable Vulnerability Scanning

```bash
# Get ECR login
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  123456789012.dkr.ecr.us-east-1.amazonaws.com

# Scan image
docker scan 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# Or use Trivy
trivy image \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# Or use Grype
grype 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
```

---

## ECR Repository Policies

### IAM Policy for ECR

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchDeleteImage",
        "ecr:DeleteRepository",
        "ecr:DeleteImage"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 2 - Part 5*
