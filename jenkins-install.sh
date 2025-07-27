#!/bin/bash

# jenkins-install.sh
# Purpose: Install Jenkins, Docker, Java 21, Maven on Amazon Linux / RHEL-based systems

set -e

echo "🔄 Updating system packages..."
sudo yum update -y

echo "📦 Installing Docker and Git..."
sudo yum install -y git docker

echo "☕ Installing Amazon Corretto Java 21..."
sudo dnf install -y java-21-amazon-corretto

echo "✅ Java version:"
java --version

echo "📦 Installing Maven..."
sudo yum install -y maven

echo "✅ Maven version:"
mvn -v

echo "📥 Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "⬆️ Upgrading system packages..."
sudo yum upgrade -y

echo "🚀 Installing Jenkins..."
sudo yum install -y jenkins

echo "✅ Jenkins version:"
jenkins --version

echo "👥 Adding Jenkins user to Docker group..."
sudo usermod -aG docker jenkins

echo "🔧 Starting and enabling Docker and Jenkins services..."
sudo systemctl start docker
sudo systemctl enable docker

sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "✅ Jenkins installation complete!"
echo "🌐 Access Jenkins on: http://<your-server-ip>:8080"
echo "🔐 Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
