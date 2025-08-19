# 🚀 AWS DevOps Project: Inventory Manager

**Objective:** Designed and deployed a **scalable inventory management web application** using modern DevOps practices, implementing a full lifecycle pipeline from **Development → Staging → Production** on AWS.

---

## 🔧 **Tech Stack**

* **Languages & Frameworks:** Python (Flask), HTML (Jinja2 templates)
* **Containerization:** Docker
* **Orchestration:** Kubernetes (EKS)
* **CI/CD:** Jenkins Pipelines
* **Infrastructure as Code (IaC):** Terraform
* **Monitoring:** Prometheus, Grafana, CloudWatch

---

## 📌 **Customer Requirement**

A multi-warehouse **Inventory Manager** app for CRUD operations, containerized and deployed on AWS with:
✅ CI/CD automation
✅ Scalable Kubernetes workloads
✅ IaC provisioning
✅ Monitoring & high availability

---

## 🧩 **Project Phases**

### 🔹 **Phase 1: Development**

* Built a Python Flask app with CRUD operations.
* Containerized using Docker & tested locally.
* Version control via GitHub.

### 🔹 **Phase 2: Staging**

* Set up **Jenkins CI/CD pipeline**: clone → build → push to ECR → deploy to EKS.
* Provisioned AWS infra (VPC, EKS, IAM) using Terraform.
* Deployed staging workloads on Kubernetes for QA.

### 🔹 **Phase 3: Production**

* Deployed multi-replica workloads on AWS EKS.
* Implemented **Blue/Green deployments** via Jenkins & Kubernetes.
* Configured **Prometheus + Grafana** for metrics and **CloudWatch** for centralized logging.
* Enabled scalability & high availability with AWS ALB Ingress Controller.

---

## 🗂 **Repository Structure**

```
inventory-manager/
├── app/                # Flask app with CRUD templates
├── Dockerfile          # Containerization
├── Jenkinsfile         # CI/CD pipeline
├── terraform/          # AWS Infra (Dev/Staging/Prod)
├── k8s/                # Kubernetes manifests
└── docs/               # Architecture & setup docs
```

---

## 🏆 **Key Outcomes**

* Automated **code-to-deployment pipeline** with Jenkins.
* Scalable, production-ready app deployed on **AWS EKS**.
* Standardized **IaC provisioning** using Terraform.
* Achieved **seamless Dev → Staging → Prod rollout** with monitoring & HA.

---

👉 **GitHub Repo:** [Inventory Manager](https://github.com/atulkamble/Inventory-Manager)

---


* ✅ Phases with customer requirements
* ✅ Code snippets
* ✅ CI/CD pipeline
* ✅ Infrastructure as Code (IaC)
* ✅ Documentation

---

## 📘 **Project Overview**

**Project Name**: `Inventory Manager`

**Customer Goal**: A scalable web application to manage product inventory across multiple warehouses. The app should be developed in Python (Flask), containerized using Docker, deployed on EKS, and managed through a CI/CD pipeline using Jenkins and Terraform.

### Clone Repo
```
git clone https://github.com/atulkamble/Inventory-Manager.git
cd Inventory-Manager
```
---
## 🧩 PHASE 1: DEVELOPMENT ENVIRONMENT

### Instance Details:
```
name - server
t3.medium 
key.pem 
SG: ssh-22, http-80, https-443, flask-5000, jenkins-8080
amazon linux 
ssd - 25 GB - gp3
```
### Connect with Instance 
```
cd Downloads 
chmod 400 key.pem 
ssh -i "key.pem" ec2-user@ec2-18-206-204-23.compute-1.amazonaws.com
```
### Update and Install Dependecies
```
sudo dnf update 
sudo dnf install python tree git docker -y

git config --global user.name "Atul Kamble"
git config --global user.email "atul_kamble@hotmail.com"
git config --list

git remote set-url origin https://atulkamble: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@github.com/atulkamble/Inventory-Manager.git

sudo systemctl start docker 
sudo systemctl enable docker 
sudo docker login 
```
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

Here’s a full example of an **Inventory Manager** app structure using **Python (Flask)** with **HTML templates**. It supports basic inventory CRUD (Create, Read, Update, Delete) operations.

---

### 📁 Project: `inventory-manager/`

```
inventory-manager/
├── app/
│   ├── main.py
│   ├── requirements.txt
│   └── templates/
│       ├── layout.html
│       ├── index.html
│       ├── add_item.html
│       └── edit_item.html
```

---

### 📄 `app/requirements.txt`

```txt
Flask==2.3.2
```

---

### 📄 `app/main.py`

```python
from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# In-memory inventory list
inventory = []

@app.route('/')
def index():
    return render_template('index.html', inventory=inventory)

@app.route('/add', methods=['GET', 'POST'])
def add_item():
    if request.method == 'POST':
        name = request.form['name']
        quantity = int(request.form['quantity'])
        price = float(request.form['price'])
        inventory.append({'id': len(inventory)+1, 'name': name, 'quantity': quantity, 'price': price})
        return redirect(url_for('index'))
    return render_template('add_item.html')

@app.route('/edit/<int:item_id>', methods=['GET', 'POST'])
def edit_item(item_id):
    item = next((i for i in inventory if i['id'] == item_id), None)
    if not item:
        return 'Item not found', 404
    if request.method == 'POST':
        item['name'] = request.form['name']
        item['quantity'] = int(request.form['quantity'])
        item['price'] = float(request.form['price'])
        return redirect(url_for('index'))
    return render_template('edit_item.html', item=item)

@app.route('/delete/<int:item_id>')
def delete_item(item_id):
    global inventory
    inventory = [item for item in inventory if item['id'] != item_id]
    return redirect(url_for('index'))

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
```

---

### 📄 `app/templates/layout.html`

```html
<!DOCTYPE html>
<html>
<head>
    <title>Inventory Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
    <h1 class="mb-4">📦 Inventory Manager</h1>
    {% block content %}{% endblock %}
</body>
</html>
```

---

### 📄 `app/templates/index.html`

```html
{% extends 'layout.html' %}

{% block content %}
<a href="{{ url_for('add_item') }}" class="btn btn-primary mb-3">➕ Add Item</a>
<table class="table table-bordered">
    <thead>
        <tr>
            <th>ID</th><th>Name</th><th>Quantity</th><th>Price</th><th>Actions</th>
        </tr>
    </thead>
    <tbody>
        {% for item in inventory %}
        <tr>
            <td>{{ item.id }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.quantity }}</td>
            <td>${{ '%.2f'|format(item.price) }}</td>
            <td>
                <a href="{{ url_for('edit_item', item_id=item.id) }}" class="btn btn-warning btn-sm">✏️ Edit</a>
                <a href="{{ url_for('delete_item', item_id=item.id) }}" class="btn btn-danger btn-sm">🗑️ Delete</a>
            </td>
        </tr>
        {% endfor %}
    </tbody>
</table>
{% endblock %}
```

---

### 📄 `app/templates/add_item.html`

```html
{% extends 'layout.html' %}

{% block content %}
<h3>Add New Item</h3>
<form method="POST">
    <div class="mb-3">
        <label>Name</label>
        <input type="text" name="name" class="form-control" required>
    </div>
    <div class="mb-3">
        <label>Quantity</label>
        <input type="number" name="quantity" class="form-control" required>
    </div>
    <div class="mb-3">
        <label>Price</label>
        <input type="number" name="price" step="0.01" class="form-control" required>
    </div>
    <button type="submit" class="btn btn-success">Add Item</button>
</form>
{% endblock %}
```

---

### 📄 `app/templates/edit_item.html`

```html
{% extends 'layout.html' %}

{% block content %}
<h3>Edit Item</h3>
<form method="POST">
    <div class="mb-3">
        <label>Name</label>
        <input type="text" name="name" class="form-control" value="{{ item.name }}" required>
    </div>
    <div class="mb-3">
        <label>Quantity</label>
        <input type="number" name="quantity" class="form-control" value="{{ item.quantity }}" required>
    </div>
    <div class="mb-3">
        <label>Price</label>
        <input type="number" name="price" step="0.01" class="form-control" value="{{ item.price }}" required>
    </div>
    <button type="submit" class="btn btn-primary">Update</button>
</form>
{% endblock %}
```

---

### ✅ How to Run

```bash
cd /home/ec2-user/Inventory-Manager/01-dev/
python3 -m venv venv
source venv/bin/activate # on Windows: venv\Scripts\activate
pip install -r requirements.txt
python main.py
deactivate
```
---

### 🐳 Dockerfile:

```dockerfile
FROM python:3.10                                                 
WORKDIR /app
COPY app/ /app/
RUN pip install -r requirements.txt
CMD ["python", "main.py"]
```

### ✅ Commands:

```bash
cd /home/ec2-user/Inventory-Manager/01-dev
sudo docker build -t atuljkamble/inventory-dev .
sudo docker images
sudo docker push atuljkamble/inventory-dev
sudo docker run -d -p 5000:5000 atuljkamble/inventory-dev
sudo docker container ls
sudo docker container stop 62bcca5a4efe
```

---

## 🧩 PHASE 2: STAGING ENVIRONMENT

### ✅ Customer Requirements:

* Staging mirror of prod for QA testing
* CI/CD with Jenkins
* Infrastructure as Code via Terraform
* Hosted on AWS EKS



### 1. Install Java (Amazon Corretto 21)

```bash
sudo dnf install java-21-amazon-corretto -y
java --version
```

### 2. Install Maven

```bash
sudo yum install maven -y
mvn -v
```

### 3. Install Jenkins

```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install jenkins -y
jenkins --version
```

### 4. Add Jenkins User to Docker Group

```bash
sudo usermod -aG docker jenkins
```

---

## ▶️ Step 5: Start Jenkins

```bash
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

---

## 🌐 Step 6: Access Jenkins Web UI

Open your browser and go to:

```
http://<YOUR_EC2_PUBLIC_IP>:8080

http://18.206.204.23:8080
```

Unlock Jenkins using the initial admin password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

f525a305e9864c96a7f0cdb18ee99875
```

Paste the password into the Jenkins setup screen and proceed.

---

## ✅ Jenkins is now ready to use!

## Configurations 

#### Install Suggested Plugins 

username: admin
passowrd: Admin@123
Full Name: Atul Kamble
email: atul_kamble@hotmail.com

Instance Configuration: http://18.206.204.23:8080/

Save and Finish

####  Start using Jenkins 


### ECR 
```
cd /Users/atul/Downloads/Inventory-Manager/01-dev
```
// docker engine in running state 

ECR >> Public Repo >> Create Repo

Repository name: atulkamble
URI: public.ecr.aws/x4u2n2b1/atulkamble
Image name: inventory-manager:staging
```
docker build -t inventory-manager:staging .

docker tag inventory-manager:staging public.ecr.aws/x4u2n2b1/atulkamble:staging

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

docker push public.ecr.aws/x4u2n2b1/atulkamble:staging
```
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
