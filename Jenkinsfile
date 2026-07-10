pipeline {
    agent any
    
    // Injects Global Tool configurations setup in Jenkins UI
    tools {
        maven 'Maven'  // Must match the exact name you used under Manage Jenkins -> Tools
        jdk 'Java 17'  // Must match the exact name you used under Manage Jenkins -> Tools
    }
    
    environment {
        DOCKER_HUB_USER = 'chiraggowda0316' // Updated based on your repository log
        IMAGE_NAME      = 'employee-management-portal'
        IMAGE_TAG       = "${BUILD_NUMBER}"
        REGISTRY_CRED   = 'docker-hub-credentials'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/chiraggowda0316/Employee-Management-Portal.git'
            }
        }

        stage('Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Unit Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy Stack (Docker Compose)') {
            steps {
                sh 'docker compose down || true'
                sh 'docker compose up -d --build'
            }
        }

        stage('Health Check') {
            steps {
                retry(5) {
                    sleep 10
                    sh 'curl --fail http://localhost:8080/employees || curl --fail http://127.0.0'
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CRED}", passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USERNAME')]) {
                    sh "echo \$DOCKER_HUB_PASSWORD | docker login -u \$DOCKER_HUB_USERNAME --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
    }
}
