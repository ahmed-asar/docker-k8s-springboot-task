# Use OpenJDK base image
FROM openjdk:11-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the jar file into the container
COPY build/libs/demo-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose port 8080
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
