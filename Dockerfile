# Step 1: Use official OpenJDK 17 base image
FROM openjdk:17-jdk-slim

# Step 2: Set working directory inside the container
WORKDIR /app

# Step 3: Copy the compiled jar from target folder to container
COPY target/*.jar app.jar

# Step 4: Expose application port 8080
EXPOSE 8080

# Step 5: Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

