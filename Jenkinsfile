pipeline {
  agent any
  stages {

    stage('Clone Repo') {
      steps { git branch: 'main', url: 'https://github.com/atulkamble/inventory-manager.git' }
    }
    stage('Build Docker') {
      steps {
        sh 'docker build -t inventory-manager:latest .'
      }
    }
    stage('Push to ECR') {
      steps {
        withCredentials([string(credentialsId: 'aws-ecr-creds', variable: 'ECR_LOGIN')]) {
          sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws'
          sh 'docker tag inventory-manager:latest public.ecr.aws/x4u2n2b1/atulkamble:latest'
          sh 'docker push public.ecr.aws/x4u2n2b1/atulkamble:latest'
        }
      }
    }
    stage('Deploy to EKS') {
      steps {
        sh 'git clone https://github.com/atulkamble/inventory-manager.git'
        sh ' cd k8s'
        sh 'kubectl apply -f k8s'
      }
    }
  }
}
