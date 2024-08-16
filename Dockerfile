
# docker muti stage build for maven and running jav file
# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and any other necessary files to download dependencies
COPY pom.xml ./

# Download dependencies and cache them
RUN mvn dependency:go-offline -B

# Copy the rest of the application source code
COPY src ./src

# Build the application
RUN mvn package -DskipTests

# Stage 2: Run the application
FROM openjdk:17-jdk-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/sample-0.0.1-SNAPSHOT.jar /app/sample.jar

# Expose the port on which the application runs
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "sample.jar"]
