# Static Website CI/CD Deployment

This project demonstrates a complete CI/CD pipeline for deploying a static website to AWS EC2 using Docker, Jenkins, and Nginx.

## Project Architecture

- **Source Code**: GitHub repository
- **CI/CD Server**: Jenkins on AWS EC2
- **Containerization**: Docker
- **Web Server**: Nginx
- **Deployment Target**: AWS EC2 (Free Tier)

## Pipeline Steps

1. Code committed to GitHub
2. GitHub webhook triggers Jenkins build
3. Jenkins builds Docker image
4. Docker image deployed to EC2 instance
5. Nginx serves the website

## Local Development

To run locally:

````bash
docker build -t static-website .
docker run -p 80:80 static-website

# Static Website CI/CD Deployment with Terraform

This project demonstrates a complete CI/CD pipeline for deploying a static website to AWS EC2 using Docker, Jenkins, Nginx, and Terraform for Infrastructure as Code.

## Architecture

- **Infrastructure as Code**: Terraform
- **Source Code**: GitHub repository
- **CI/CD Server**: Jenkins on AWS EC2
- **Containerization**: Docker
- **Web Server**: Nginx
- **Deployment Target**: AWS EC2 (Free Tier)

## Terraform Management

### Initialize Terraform
```bash
terraform init

````

# Static Website CI/CD Deployment with Terraform and Jenkins

This project demonstrates a complete CI/CD pipeline for deploying a static website to AWS EC2 using Docker, Jenkins, Nginx, and Terraform for Infrastructure as Code.

## Architecture

- **Infrastructure as Code**: Terraform
- **Source Code**: GitHub repository
- **CI/CD Server**: Jenkins on AWS EC2
- **Containerization**: Docker
- **Web Server**: Nginx
- **Deployment Target**: AWS EC2 (Free Tier)
- **Automation**: GitHub Webhooks

## Pipeline Workflow

1. Code is pushed to GitHub
2. GitHub webhook triggers Jenkins pipeline
3. Jenkins checks out the code
4. Tests are run to validate the code
5. Docker image is built
6. Image is deployed to EC2 instance
7. Deployment is verified

## How to Use

### Manual Trigger

1. Push changes to GitHub
2. Jenkins automatically builds and deploys

### Manual Deployment

```bash
# Build the Docker image
docker build -t static-website .

# Run the container locally
docker run -p 80:80 static-website

# Deploy manually to EC2
./deploy.sh
```
