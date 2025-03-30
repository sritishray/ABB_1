# Use an official OpenJDK image as the base image
FROM openjdk:17

# Switch to root for installation
USER root

# Set working directory
WORKDIR /app

# Copy the Java source file
COPY HelloWorld.java .

# Install dependencies and compile Java file
RUN javac HelloWorld.java

# Create a non-root user and switch to it
RUN useradd -m javauser
USER javauser

# Run the Java application as a non-root user
CMD ["java", "HelloWorld"]