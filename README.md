# spring-boot-k8s-deployment

This repository was originally hosted on Azure DevOps and has been shared here on GitHub for demonstration purposes. 

All original work and CI/CD configurations were implemented and tested using Azure DevOps.

*Original repository URL:* [Azure DevOps Repo](https://dev.azure.com/seahmedadel/_git/spring-boot-k8s-deployment)
---


## 1. Overview
This task serves as a practical assessment for a **Junior DevOps Engineer** vacancy. The goal is to demonstrate my proficiency in coding, testing, automation, deployment, and documentation skills.

![CI/CD Pipeline for Spring Boot Application with Kubernetes Deployment](CICD%20Pipeline%20for%20Spring%20Boot%20Application%20with%20Kubernetes%20Deployment.png)


The diagram above illustrates the flow of development and production environments. 

### Tools and Technologies Used:
- **Gradle**: To build the JAR file for the Spring Boot application.
- **Docker**: To containerize the Spring Boot application.
- **Docker Hub**: As the container image registry.
- **Azure DevOps**: For the CI/CD pipeline and code repository.
- **SonarQube**: For static code analysis and quality checks.
- **Kubernetes Cluster (Managed by Linode)**: For application deployment.

---

## 2. Repository Structure
**Repository Name**: `spring-boot-k8s-deployment`

**Folder Structure**:
- **build**: Contains build artifacts.
- **config**: Configuration files, such as Kubernetes manifests.
- **deployment**: Deployment-related scripts and manifests.
- **gradle**: Gradle wrapper files.
- **src**: Source code for the Spring Boot application.

**Files**:
- `.gitignore`: To specify untracked files.
- `azure-pipelines.yml`: CI/CD pipeline configuration.
- `build.gradle`: Build tool configuration for Gradle.
- `Dockerfile`: Instructions for containerizing the application.
- `gradlew`, `gradlew.bat`: Gradle wrapper scripts for Unix and Windows.
- `settings.gradle`: Additional Gradle configuration.

**Branching Strategy**:
- **`dev` branch**: Triggers deployment to the development environment upon changes.
- **`main` branch**: Triggers deployment to the production environment upon merges.

---

## 3. Dockerization
### Dockerfile:
```dockerfile
# Use OpenJDK base image
FROM openjdk:11-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the jar file into the container
COPY build/libs/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8080
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
```

### Steps to Build and Run the Dockerized Application:
1. Build the Docker image:
   ```bash
   docker build -t seahmedadel/spring-boot-app:latest .
   ```
2. Run the containerized application:
   ```bash
   docker run -d -p 8080:8080 docker.io/seahmedadel/spring-boot-app:latest
   ```

---

## 4. CI/CD Pipeline
### Pipeline Stages:
1. **Lint Stage**: Automated source code checks using `gradlew check`.
2. **Unit Test Stage**: Executes unit tests using `gradlew test`.
3. **SonarQube Integration**:
   - SonarQube deployed as a container on Linode with a PostgreSQL database.
   - Stage configuration using `SonarQubePrepare@5`.
4. **Build Image Stage**: Builds the Docker image from the `Dockerfile`.
5. **Push Image Stage**: Pushes the Docker image to Docker Hub.
6. **Pull Image Stage**: Pulls the Docker image from Docker Hub for validation.
7. **Deploy Stage**:
   - Retrieves the kubeconfig file.
   - Configures kubeconfig for `kubectl`.
   - Tests connectivity to the cluster.
   - Deploys Kubernetes manifests (`deployment.yml`, `service.yml`, `ingress.yml`).

### Azure DevOps Configuration:
- **Self-Hosted Agent**: A Linode VPS configured as the build agent.
- **Service Connections**:
  - Docker Hub.
  - Kubernetes cluster.
  - SonarQube server.

---

## 5. Kubernetes Deployment
### Environment Setup:
- **Cluster Type**: Development cluster with two worker nodes.
- **Cloud Provider**: Linode.
- **Storage**: 50 GB shared storage for persistent workloads.

### Specifications:
- Each node:
  - **1 vCPU**.
  - **2GB RAM**.
  - Hosted on Linode's 2GB plan.

### Access:
- Managed using `kubectl` and a securely configured kubeconfig file.
- Provisioned with Linode Kubernetes Engine (LKE), a fully managed Kubernetes service.

### Manifests Deployed:
- **Deployment**: Deploys the Spring Boot application.
- **Service**: Exposes the application internally within the cluster.
- **Ingress**: Configures external access with a `/live` endpoint for liveness checks.

---

Here’s how you can structure the Challenges and Solutions section with both challenges and their proposed solutions:

## 6. Challenges and Solutions
- **Challenge 1**:Insufficient Resources for Separate Development and Production Environments
Due to the limited resources available, I was unable to create fully isolated development and production environments. As a result, I had to create a single pipeline with separate stages for dev and prod deployments. Initially, both the dev and prod Kubernetes manifests had identical values. This setup worked for the time being, but it was not an ideal solution for proper environment separation.

- **Solution**:
To address this challenge, I opted to keep the dev and prod stages within the same pipeline for simplicity. However, the solution to fully isolate the environments is to set up a separate Kubernetes cluster for the prod environment. The prod Kubernetes manifest values will then be adjusted accordingly, ensuring that the production deployment is isolated and configured with optimal settings (e.g., scaling, resource allocation). This approach will ensure that the dev and prod environments are properly separated, enabling better scalability, security, and resource management.

- **Challenge 2**: SonarQube Analysis Failing Due to License Limitation
While running the SonarQube analysis in the CI/CD pipeline, I encountered an error that halted the build process. The error message indicated that "To use the property sonar.branch.name and analyze branches, Developer Edition or above is required." This was due to the SonarQube instance in use being a version that does not support branch analysis.

- **Solution**:
To resolve this issue, I identified that the current SonarQube version was insufficient for analyzing different branches. The solution is to either upgrade to the Developer Edition of SonarQube or modify the pipeline to avoid using features that require this version. If upgrading to the Developer Edition is not feasible, an alternative solution could be to configure SonarQube to run analysis on the default branch or refactor the pipeline to handle branch analysis differently, possibly by using workarounds like manual triggering or separate analysis tasks.

---

## 7. Conclusion
The pipeline efficiently integrates key stages such as source code linting, testing, quality analysis, containerization, and automated deployment. By leveraging Azure DevOps for CI/CD, it ensures seamless versioning and environment-specific deployments, while Kubernetes provides a robust platform for scaling and managing the application. Docker simplifies dependency management and portability, making the application easy to deploy across different environments.

This task demonstrates my ability to set up and automate a full development lifecycle, including handling challenges related to resource limitations and tool versioning. It showcases my skills in implementing CI/CD pipelines, containerization, and deployment on Kubernetes—essential capabilities for a Junior DevOps Engineer role. Through this project, I’ve further honed my problem-solving skills, adaptability, and ability to implement efficient, automated processes in real-world scenarios.
