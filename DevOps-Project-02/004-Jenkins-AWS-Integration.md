# 004 - Jenkins AWS Integration

**Module 3 - Part 4**  
**Topic:** Integrating Jenkins with AWS services (EC2, ECR, S3)

---

## AWS Credentials Configuration

### Configure in Jenkins

```groovy
// Jenkins Credentials
// Go to: Manage Jenkins → Credentials

// Add AWS Credentials:
// - ID: aws-ec2-credentials
// - Type: AWS Credentials
// - Access Key ID
// - Secret Access Key

// Or use file-based credentials
credentials([
    usernameCredentials('aws-access-key'),
    passwordCredentials('aws-secret-key')
]) {
    steps {
        // Use credentials in pipeline
    }
}
```

### IAM Role for EC2

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
        "ecr:StartLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "arn:aws:ecr:*:123456789012/repository/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## Deploy to S3

### Upload Build Artifact to S3

```groovy
pipeline {
    agent any

    environment {
        S3_BUCKET = 'myapp-artifacts'
        REGION = 'us-east-1'
    }

    stages {
        stage('Upload to S3') {
            steps {
                sh '''
                    # Configure AWS CLI
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                    aws configure set region $REGION
                    
                    # Upload artifact
                    aws s3 cp target/myapp.jar s3://${S3_BUCKET}/latest/ --recursive
                    
                    # List uploaded files
                    aws s3 ls s3://${S3_BUCKET}/latest/
                    '''
                }
            }
        }
    }
}
```

---

## Deploy to EC2

### Launch EC2 from S3 Artifact

```groovy
pipeline {
    agent any

    stages {
        stage('Deploy to EC2') {
            steps {
                sh '''
                    # Get ECR auth
                    aws ecr get-login-password | \
                        docker login --username AWS --password-stdin \
                        123456789012.dkr.ecr.us-east-1.amazonaws.com
                    
                    # Build and push
                    docker build -t myapp .
                    docker tag myapp \
                        123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
                    docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
                    
                    # SSH to EC2 and deploy
                    scp -i key.pem target/myapp.jar ec2-user@ec2-instance:/var/app/
                    '''
                }
            }
        }
    }
}
```

---

## ECS Deployment

### Deploy to ECS

```groovy
pipeline {
    agent any

    environment {
        ECR_REPO = 'myapp'
        CLUSTER = 'my-cluster'
        SERVICE = 'myapp-service'
    }

    stages {
        stage('Build and Push') {
            steps {
                sh '''
                    aws ecr get-login-password | \
                        docker login --username AWS --password-stdin \
                        123456789012.dkr.ecr.us-east-1.amazonaws.com
                    
                    docker build -t myapp .
                    docker tag myapp \
                        123456789012.dkr.ecr.us-east-1.amazonaws.com/${ECR_REPO}:latest
                    docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/${ECR_REPO}:latest
                    '''
            }
        }
        
        stage('Update ECS Service') {
            steps {
                sh '''
                    # Update ECS service with new image
                    aws ecs update-service \
                        --cluster ${CLUSTER} \
                        --service ${SERVICE} \
                        --task-definition my-task-def \
                        --force-new-deployment
                    
                    # Wait for service to stabilize
                    aws ecs wait services-stable \
                        --cluster ${CLUSTER} \
                        --services ${SERVICE}
                    '''
                }
            }
        }
    }
}
```

---

## Route 53 DNS Management

### Update DNS

```groovy
pipeline {
    agent any

    stages {
        stage('Update DNS') {
            steps {
                sh '''
                    # Update Route 53 DNS
                    aws route53 change-resource-record-sets \
                        --hosted-zone-id Z1234567890ABC \
                        --change-batch file://batch.json
                    
                    # batch.json content:
                    {
                        "ChangeBatch": {
                            "Actions": [
                                {
                                    "Action": "CREATE",
                                    "ResourceRecordSet": {
                                        "Name": "myapp.example.com",
                                        "Type": "A",
                                        "AliasTarget": {
                                            "HostedZoneId": "Z1234567890ABC",
                                            "DNSName": "myapp.dkr.ecr.us-east-1.amazonaws.com",
                                            "EvaluatedTargetHealth": {}
                                        },
                                        "Weight": 100
                                    }
                                }
                            ]
                        }
                    }
                    '''
                }
            }
        }
    }
}
```

---

## CloudFront Integration

### Deploy to CloudFront

```groovy
pipeline {
    agent any

    stages {
        stage('Deploy to CloudFront') {
            steps {
                sh '''
                    # Create/update CloudFront distribution
                    aws cloudfront create-distribution \
                        --origin-identity-hosted-zone-id Z1234567890ABC \
                        --origin-domain-name s3.${S3_BUCKET}.s3.amazonaws.com \
                        --default-root-object index.html \
                        --default-cache-behavior \
                        --default-cache-behavior-cache-policyId \
                        658327ea90e2b \
                        --http-port 80 \
                        --https-port 443 \
                        --default-root-object index.html \
                        --viewer-protocol-policy "RedirectToHTTPS" \
                        --default-origin-request-policy-id K2THJDFAG7585
                    '''
                }
            }
        }
    }
}
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 3 - Part 4*
