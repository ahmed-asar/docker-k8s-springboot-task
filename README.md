
# Hiring Task - Junior DevOps Engineer

## 1. Overview
This task serves as a practical assessment for a **Junior DevOps Engineer** vacancy. The goal is to demonstrate my proficiency in coding, testing, automation, deployment, and documentation skills.

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

## 6. Conclusion
The pipeline efficiently integrates source code linting, testing, quality analysis, containerization, and automated deployment. Utilizing Azure DevOps for CI/CD ensures seamless versioning and environment-specific deployments. Kubernetes provides a robust platform for scaling and managing the application, while Docker simplifies dependency management and portability.

This task highlights my ability to set up and automate a full development lifecycle, demonstrating essential skills required for a Junior DevOps Engineer role.
