# 006 - AWS EC2 and ECS Deployment

**Module 2 - Part 6**  
**Topic:** Deploying Docker containers on AWS EC2 and ECS

---

## Deploying to EC2

### Install Docker on EC2

```bash
# SSH into EC2 instance
ssh -i your-key.pem ec2-user@<public-ip>

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ec2-user

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Verify installation
docker run hello-world
```

### Build and Deploy on EC2

```bash
# Build image
docker build -t myapp:1.0 .

# Tag for ECR
aws ecr get-login-password | \
  docker login --username AWS --password-stdin \
  123456789012.dkr.ecr.us-east-1.amazonaws.com

docker tag myapp:1.0 \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# Push to ECR
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# Pull to EC2
docker pull 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# Run container
docker run -d \
  --name myapp \
  -p 8000:8000 \
  --restart unless-stopped \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
```

### EC2 Security Groups

```bash
# Edit security group in AWS Console
# OR use AWS CLI:
aws ec2 modify-security-group-ribgroup \
  --group-id sg-xxxx \
  --ip-permissions \
  --ip-permissions 'FromPort=80,ToPort=80,IpProtocol=tcp,IpRanges=[{CidrIp=0.0.0.0/0,}]'
```

---

## ECS (Elastic Container Service) Basics

### Create ECS Cluster

```bash
# Create cluster (ECS CLI)
ecs-cli-plugin install

# Configure AWS credentials
aws configure

# Create cluster
aws ecs create-cluster \
  --cluster-name my-cluster

# Describe cluster
aws ecs describe-clusters --cluster my-cluster
```

### ECS Service

```bash
# Create service
aws ecs create-service \
  --cluster my-cluster \
  --service-name myapp \
  --task-definition my-task-def \
  --desired-count 2 \
  --launch-type FARGATE \
  --platform-family my-platform \
  --network-configuration \
    'awsvpcConfiguration=subnets=sub-xxxxx,securityGroups=sg-xxxxx,assignPublicIp=ENABLED'

# Update service
aws ecs update-service \
  --cluster my-cluster \
  --service myapp \
  --desired-count 3
```

### Task Definition

```json
{
  "family": "my-task",
  "networkMode": "awsvpc",
  " RequiresAttributes": [
    {
      "value": "com.amazonaws.ecs.capability.ecr-auth"
    }
  ],
  "volumes": [],
  "placementConstraints": [],
  "containerDefinitions": [
    {
      "name": "web",
      "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0",
      "portMappings": [
        {
          "containerPort": 8000,
          "hostPort": 8000,
          "protocol": "tcp"
        }
      ],
      "essential": true,
      "environment": [
        {
          "name": "FLASK_ENV",
          "value": "production"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/myapp",
          "awslogs-region": "us-east-1",
          "awslogs-stream-placeholder": "${ECS_TASK_LOG_GROUP}"
        }
      }
    }
  ]
}
```

---

## ECS Deployment Workflow

### Deploy Pipeline

```bash
# 1. Build and push image
docker build -t myapp .
aws ecr get-login-password | \
  docker login --username AWS --password-stdin \
  123456789012.dkr.ecr.us-east-1.amazonaws.com
docker tag myapp:1.0 \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# 2. Register task definition
TASK_DEF_FILE="task-definition.json"
aws ecs register-task-definition \
  --cli-input-json file://$TASK_DEF_FILE

# 3. Create service
TASK_DEF=$(aws ecs describe-task-definitions \
  --task-definition my-task-def \
  --query 'taskDefinitions[0].taskDefinitionArn' \
  --output text)

aws ecs create-service \
  --cluster my-cluster \
  --service myapp \
  --task-definition $TASK_DEF \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration \
    'awsvpcConfiguration=subnets=sub-xxxxx,securityGroups=sg-xxxxx,assignPublicIp=ENABLED'

# 4. Wait for service to be running
aws ecs wait services-stable \
  --cluster my-cluster \
  --services myapp

# 5. Describe service
aws ecs describe-services \
  --cluster my-cluster \
  --services myapp
```

---

## ECS Monitoring

```bash
# View ECS tasks
aws ecs describe-tasks \
  --cluster my-cluster \
  --task-ids $(aws ecs list-tasks \
    --cluster my-cluster \
    --service myapp \
    --query 'taskArns[].split(":")[1]' \
    --output text)

# View ECS logs
aws logs tail -f /ecs/myapp

# Describe task
aws ecs describe-tasks \
  --cluster my-cluster \
  --tasks $(aws ecs list-tasks \
    --cluster my-cluster \
    --service myapp \
    --query 'taskArns[].split(":")[1]' \
    --output text)
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 2 - Part 6*
