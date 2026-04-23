# Build stage - Build the JAR
FROM maven:3.6-openjdk-8 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage - Run with Tomcat
FROM tomcat:9.0.50-jdk8
COPY --from=builder /app/target/*.war /app/webapps/ROOT.war

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1
