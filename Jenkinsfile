pipeline {
    agent any
    
    environment {
        DOCKER_HUB_USER = 'your_dockerhub_username' // Change this to your actual username
        IMAGE_NAME      = 'employee-management-portal'
        IMAGE_TAG       = "${BUILD_NUMBER}"
        REGISTRY_CRED   = 'docker-hub-credentials' // Jenkins Credentials ID
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

        stage('Remove Old Container') {
            steps {
                sh '''
                    docker stop employee-app-container || true
                    docker rm employee-app-container || true
                '''
            }
        }

        stage('Run New Container') {
            steps {
                // Runs the isolated application container (assumes MySQL is already running or managed externally)
                sh "docker run -d --name employee-app-container -p 8080:8080 ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Health Check') {
            steps {
                retry(5) {
                    sleep 10
                    sh 'curl --fail http://localhost:8080/actuator/health || curl --fail http://localhost:8080/'
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

