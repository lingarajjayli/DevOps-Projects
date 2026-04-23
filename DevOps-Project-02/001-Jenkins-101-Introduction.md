# 001 - Jenkins CI/CD Fundamentals

**Module 3 - Part 1**  
**Project:** DevOps-Project-02 - Jenkins on AWS

---

## Overview

Jenkins is the industry-leading CI/CD automation server. This module covers:
- CI/CD pipeline concepts
- Jenkins installation and configuration
- Building and managing pipelines
- AWS integration
- Docker in CI/CD

---

## What is CI/CD?

### Continuous Integration (CI)

**Definition:** Developers frequently merge code into a shared repository, triggering automated builds and tests.

**Benefits:**
- Catch bugs early
- Reduce integration issues
- Automated testing
- Faster feedback

### Continuous Deployment/Delivery (CD)

**Continuous Deployment:** Every change automatically deployed to production

**Continuous Delivery:** Every change ready for production (manual approval needed)

---

## CI/CD Pipeline Stages

```
┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐
│  Code   │→ │   Build │→ │  Test  │→ │  Deploy │→ │  Monitor │
│ Commit  │  │  Stage  │  │  Stage  │  │  Stage  │  │   Stage  │
└─────────┘  └─────────┘  └─────────┘  └─────────┘  └─────────┘
   ↑            ↑            ↑            ↑            ↑
Developer   Code       Unit      Staging    Production   Alerts
  Push     Quality     Tests      Env        Env         System
```

---

## Jenkins Architecture

### Components

```
┌─────────────────────────────────────┐
│         Jenkins Master              │
│  ┌─────────────────────────────────┐│
│  │  Jenkins Controller              ││
│  │  - UI                           ││
│  │  - Queue Manager                ││
│  └─────────────────────────────────┘│
│  ┌─────────────────────────────────┐│
│  │  Jenkins Agents (Workers)       ││
│  │  - Build Executor Agents        ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

### Pipeline Concepts

| Component | Purpose |
|-----------|--|--|
| **Pipeline** | Complete automation workflow |
| **Stage** | Pipeline phase (Build, Test, Deploy) |
| **Step** | Task within a stage |
| **Agent** | Machine that runs jobs |
| **Node** | Machine pool in Jenkins |

---

## Maven Fundamentals

### Maven Project Structure

```
project/
├── pom.xml              # Maven config
├── src/
│   ├── main/
│   │   ├── java/        # Source code
│   │   └── resources/   # Config files
│   └── test/            # Test code
└── target/              # Build output
```

### pom.xml Basics

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>myapp</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>5.3.20</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>2.22.2</version>
            </plugin>
        </plugins>
    </build>
</project>
```

---

## Maven Commands

| Command | Description |
|---------|---|
| `mvn clean` | Clean build artifacts |
| `mvn compile` | Compile source code |
| `mvn test` | Run unit tests |
| `mvn package` | Build jar/war |
| `mvn verify` | Full lifecycle |
| `mvn install` | Install to local repo |
| `mvn clean install` | Clean + install |

---

## Maven in Jenkins Pipeline

### Pipeline Script

```groovy
pipeline {
    agent any

    stages {
        stage('Clean') {
            steps {
                sh 'mvn clean'
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                sh 'mvn package'
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

*Module 3 - Part 1*
