pipeline {
  agent any
  environment {
    APP_NAME = "sample-java-app"
    IMAGE_NAME = "<DOCKERHUB_REPO>/${APP_NAME}"            // replace <DOCKERHUB_REPO> (e.g., yourdockerhubuser)
    IMAGE_TAG  = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.substring(0,7)}"
    SSH_USER = "ec2-user"
    EC2_HOST = "<EC2_HOST>" // replace with your EC2 public IP or hostname
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'mvn -B clean package -DskipTests=false'
      }
    }

    stage('Unit Tests') {
      steps {
        sh 'mvn test'
      }
    }

    stage('Docker Build & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            docker --version || true
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
            docker push ${IMAGE_NAME}:${IMAGE_TAG}
          '''
        }
      }
    }

    stage('Deploy to EC2') {
      steps {
        sshagent (credentials: ['ec2-ssh-key']) {
          sh """
            ssh -o StrictHostKeyChecking=no ${SSH_USER}@${EC2_HOST} 'bash -s' < ./deploy/deploy.sh ${IMAGE_NAME} ${IMAGE_TAG}
          """
        }
      }
    }
  }

  post {
    always {
      cleanWs()
    }
    success {
      echo "Pipeline succeeded: ${IMAGE_NAME}:${IMAGE_TAG}"
    }
    failure {
      echo "Pipeline failed"
    }
  }
}
