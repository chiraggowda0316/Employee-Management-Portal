# Use the official production-ready Eclipse Temurin OpenJDK 17 image
FROM eclipse-temurin:17-jdk-alpine

# Set working directory inside the container
WORKDIR /app

# Copy the compiled jar from target folder to container
COPY target/*.jar app.jar

# Expose application port 8080
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
