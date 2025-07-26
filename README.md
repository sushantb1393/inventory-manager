**AWS DevOps project plan** from **Development → Staging → Production**, with tools including **Python, Git, Docker, Jenkins, Kubernetes, Terraform**, and includes:

* ✅ Phases with customer requirements
* ✅ Code snippets
* ✅ CI/CD pipeline
* ✅ Infrastructure as Code (IaC)
* ✅ Documentation

---

## 📘 **Project Overview**

**Project Name**: `Inventory Manager`

**Customer Goal**: A scalable web application to manage product inventory across multiple warehouses. The app should be developed in Python (Flask), containerized using Docker, deployed on EKS, and managed through a CI/CD pipeline using Jenkins and Terraform.

---

## 🧩 PHASE 1: DEVELOPMENT ENVIRONMENT

### ✅ Customer Requirements:

* Rapid Python web app development
* Local testing with Docker
* Source code versioned with Git

### 📁 Project Structure:

```
inventory-manager/
├── app/
│   ├── main.py
│   ├── requirements.txt
│   └── templates/
├── Dockerfile
├── docker-compose.yml
├── .gitlab-ci.yml or Jenkinsfile
└── terraform/
```

### 🧪 Sample Python Code: `main.py`

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Inventory Manager - Dev"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

### 🐳 Dockerfile:

```dockerfile
FROM python:3.10
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "main.py"]
```

### ✅ Commands:

```bash
docker build -t inventory-dev .
docker run -p 5000:5000 inventory-dev
```

---

## 🧩 PHASE 2: STAGING ENVIRONMENT

### ✅ Customer Requirements:

* Staging mirror of prod for QA testing
* CI/CD with Jenkins
* Infrastructure as Code via Terraform
* Hosted on AWS EKS

---

### 🧰 Jenkins CI/CD Pipeline

**Jenkinsfile**

```groovy
pipeline {
  agent any
  stages {
    stage('Clone') {
      steps { git 'https://github.com/yourorg/inventory-manager.git' }
    }
    stage('Build Docker') {
      steps {
        sh 'docker build -t inventory-manager:staging .'
      }
    }
    stage('Push to ECR') {
      steps {
        withCredentials([string(credentialsId: 'aws-ecr-creds', variable: 'ECR_LOGIN')]) {
          sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account_id>.dkr.ecr.us-east-1.amazonaws.com'
          sh 'docker tag inventory-manager:staging <ecr-repo>'
          sh 'docker push <ecr-repo>'
        }
      }
    }
    stage('Deploy to EKS') {
      steps {
        sh 'kubectl apply -f k8s/staging-deployment.yaml'
      }
    }
  }
}
```

---

### ☁️ Terraform for AWS Infra (VPC, EKS, IAM)

**Directory**: `terraform/staging/`

```hcl
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "staging-vpc"
  cidr   = "10.0.0.0/16"
  ...
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "staging-cluster"
  ...
}
```

```bash
cd terraform/staging/
terraform init
terraform apply
```

---

## 🧩 PHASE 3: PRODUCTION ENVIRONMENT

### ✅ Customer Requirements:

* High availability & scalability
* Monitoring & alerting
* Blue/Green deployments

---

### 🛠 Kubernetes Setup

**Prod Deployment YAML**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: inventory-prod
spec:
  replicas: 3
  selector:
    matchLabels:
      app: inventory
  template:
    metadata:
      labels:
        app: inventory
    spec:
      containers:
        - name: inventory-app
          image: <ecr-repo>:prod
          ports:
            - containerPort: 5000
```

### 🔁 Blue/Green Deploy (Kubernetes + Jenkins)

* Use 2 deployments (`inventory-green` and `inventory-blue`)
* Use `kubectl rollout` for switching traffic
* Add a test phase in Jenkins before final switch

---

## 📊 Monitoring

* **Prometheus + Grafana** for metrics
* **CloudWatch** for logs
* **ALB Ingress Controller** for traffic routing

---

## 🗂 GitHub Repo Structure

```
inventory-manager/
├── app/
├── Dockerfile
├── Jenkinsfile
├── terraform/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── k8s/
│   ├── staging-deployment.yaml
│   └── prod-deployment.yaml
├── docs/
│   └── architecture.md
```

---

## 📝 Documentation Example: `docs/architecture.md`

```
# Inventory Manager Architecture

- Python Flask app containerized via Docker
- Jenkins automates CI/CD from Git to EKS
- Terraform provisions AWS resources (VPC, EKS, IAM)
- EKS handles scalable Kubernetes workloads
- Prometheus/Grafana monitor app health
```
---
