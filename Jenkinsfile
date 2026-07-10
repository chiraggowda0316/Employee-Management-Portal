pipeline {
    agent any
    
    environment {
        DOCKER_HUB_USER = 'chiraggowda0316'
        IMAGE_NAME      = 'employee-management-portal'
        IMAGE_TAG       = "${BUILD_NUMBER}"
        REGISTRY_CRED   = 'docker-hub-credentials'
    }

    stages {
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
                // Connects directly to your established Task 5 container environment network
                sh "docker run -d --name employee-app-container --network employee-management-portal_default -p 8080:8080 -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/employee_db?allowPublicKeyRetrieval=true&useSSL=false -e SPRING_DATASOURCE_USERNAME=admin -e SPRING_DATASOURCE_PASSWORD=admin123 ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
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
