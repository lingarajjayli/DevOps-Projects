# =====================================================================
# =====================================================================
# Dockerfile - Spring Boot Login Application
# =====================================================================
# Multi-stage Dockerfile for building and running a Spring Boot WAR app
# =====================================================================

# =====================================================================
# Stage 1: Build Stage - Use Maven to compile and package the app
# =====================================================================
FROM maven:3.8.5-openjdk-8 AS builder

# Set working directory
WORKDIR /app

# Copy Maven configuration
COPY pom.xml .

# Copy source code
COPY src ./src

# Install dependencies and build the WAR file
# -DskipTests: Skip tests during build (run separately)
RUN mvn clean package -DskipTests \
    && mv target/*.war app.war

# =====================================================================
# Stage 2: Runtime Stage - Use Tomcat to serve the WAR
# =====================================================================
FROM tomcat:9.0.90-jdk8-openjdk-8

# Copy the WAR file from builder stage
COPY --from=builder /app/app.war /app/webapps/ROOT.war

# Copy application.properties (optional - mount from outside if needed)
# COPY --from=builder /app/application.properties /app/conf/Catalina/localhost/

# Remove Tomcat's default webapps
RUN rm -rf /app/webapps/*

# Set proper permissions
RUN chown -R tomcat:tomcat /app

# Expose the port
EXPOSE 8080

# Health check (optional - requires curl installed in base image)
HEALTHCHECK --interval=30s --timeout=3 --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]
