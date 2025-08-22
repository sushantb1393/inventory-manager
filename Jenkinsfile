pipeline {
  agent any
  options {
    skipDefaultCheckout(true)
    timestamps()
  }
  environment {
    REGISTRY        = 'docker.io'
    DOCKERHUB_REPO  = 'atuljkamble/inventory-manager'       // <— your Docker Hub repo
    IMAGE_TAG       = "${env.BRANCH_NAME ?: 'main'}-${env.BUILD_NUMBER}"
    FULL_IMAGE      = "${env.DOCKERHUB_REPO}:${env.IMAGE_TAG}"
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/atulkamble/inventory-manager.git'
      }
    }

    stage('Build Docker') {
      steps {
        sh """
          docker build -t ${FULL_IMAGE} .
          docker tag ${FULL_IMAGE} ${DOCKERHUB_REPO}:latest
        """
      }
    }

    stage('Login & Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'DH_USER',
          passwordVariable: 'DH_PASS'
        )]) {
          sh """
            echo "${DH_PASS}" | docker login -u "${DH_USER}" --password-stdin ${REGISTRY}
            docker push ${FULL_IMAGE}
            docker push ${DOCKERHUB_REPO}:latest
            docker logout ${REGISTRY}
          """
        }
      }
    }

   
  }

  post {
    always {
      echo "Build: ${env.BUILD_NUMBER} finished with status: ${currentBuild.currentResult}"
    }
    cleanup {
      // Optional local cleanup to save space
      sh "docker image prune -f || true"
    }
  }
}
