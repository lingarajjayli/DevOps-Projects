# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **DevOps learning repository** containing beginner-to-advanced projects for aspiring DevOps engineers. The repository structure contains multiple independent subprojects:

- **DevOps Project-01** / Java-Login-App - A Spring Boot login/register web application
- **DevOps Project-02** - Contains HTML web app tutorials and VPC architecture configuration files
- **Project-01.md**, **Project-02.md** - Project documentation files

## Architecture

### Java Login App Structure
Located at `DevOps Project-01/Java-Login-App/`:

```
Java-Login-App/
├── pom.xml (Maven build configuration)
├── src/main/java/com/dpt/demo/
│   ├── HomeController.java - Main controller
│   ├── MyWebAppApplication.java - Spring Boot entry point
│   ├── ServletInitializer.java - WAR deployment init
│   ├── login.java - Login logic
│   ├── register.java - Registration logic
│   └── HomeController.java - Home page controller
├── src/main/webapp/pages/
│   ├── login.jsp - Login page
│   ├── register.jsp - Registration page
│   ├── home.jsp - Home page
│   ├── user.jsp - User profile page
│   ├── confirm.jsp - Confirmation page
│   ├── fail.jsp - Error page
│   └── ...
└── src/test/java/com/dpt/demo/MyWebAppApplicationTests.java
```

### Build System
- **Maven** (`pom.xml`) - Uses Spring Boot 2.2.4.RELEASE
- **Java 8** (`<java.version>1.8</java.version>`)
- **Packaging:** WAR file

### Key Dependencies
- Spring Boot Web Starter
- MySQL Connector (runtime)
- Spring Boot Tomcat (provided scope)
- Spring Boot Test (test scope)

## Build and Development Commands

### Java Login App Commands

**Build:**
```bash
cd "DevOps Project-01/Java-Login-App"
mvn clean package
```

**Run Tests:**
```bash
cd "DevOps Project-01/Java-Login-App"
mvn test
```

**Run Single Test:**
```bash
cd "DevOps Project-01/Java-Login-App"
mvn test -Dtest=MyWebAppApplicationTests
```

**Build WAR:**
```bash
cd "DevOps Project-01/Java-Login-App"
mvn clean install
```

**Run Application:**
```bash
cd "DevOps Project-01/Java-Login-App"
mvn spring-boot:run
```

**Serve WAR locally:**
```bash
cd "DevOps Project-01/Java-Login-App"
mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Dloader.web-base-path=/"
```

## Development Notes

### Maven Build Configuration
- Distribution management is configured for artifact repository deployment
- WAR packaging requires servlet container (Tomcat) in the hosting environment
- Tests use JUnit 5 (vintage engine excluded)

### Git Workflow
- Main branch: `master`
- Common operations:
  - Check status: `git status`
  - View diff: `git diff`
  - Create commit: `git commit -m "message"`
  - Push: `git push origin <branch>`

### Ignored Files
The Java-Login-App `.gitignore` excludes:
- Compiled files: `*.class`, `target/`, `*.jar`, `*.war`
- IDE files: `.idea/`
- Build artifacts: `dist/`, `node_modules/`
- Logs: `*.log`

## Project Context

This repository is designed for **hands-on DevOps learning** and includes:
- Beginner projects: Foundational DevOps concepts
- Intermediate projects: Complex DevOps fundamentals
- Advanced projects: Industry-level practices

### Topics Covered
- Automated Deployment
- CI/CD Pipelines
- Infrastructure as Code (IaC)
- Monitoring & Logging
- Security & Compliance
- Scalability & Performance Optimization

## Key Files Reference

### Configuration
- `pom.xml` - Maven dependencies and build configuration
- `application.properties` - Spring Boot configuration (Java-Login-App)
- `WEB-INF/web.xml` - Web application deployment descriptor (html-web-app)

### Documentation
- `README.md` - Repository overview and learning path
- `CODE_OF_CONDUCT.md` - Community guidelines
- `DevOps Project-01/Project-01.md` - Project-01 documentation
- `DevOps Project-02/Project-02.md` - Project-02 documentation

## Tips for Working with This Repository

1. **Each subproject is independent** - Work in specific directories (e.g., `cd "DevOps Project-01/Java-Login-App"` for Java app)
2. **Check project-specific documentation** - Read `.md` files in each project subdirectory
3. **Maven is the build tool** - Use `mvn` commands for build, test, and package operations
4. **Spring Boot 2.2.4** - This is an older version; ensure compatibility with required libraries
5. **WAR packaging** - The app needs a servlet container (Tomcat, Jetty, etc.) to run
