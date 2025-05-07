pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') // Docker Hub credentials ID
        DOCKER_IMAGE = "mukiwa/mitra-techday-website" // Docker Hub image name
        GIT_REPO = 'https://github.com/Astonie/mitra-techday-website.git'
        KUBECONFIG = 'C:\\jenkins_home\\.kube\\config' // Windows path to kubeconfig
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "${GIT_REPO}", credentialsId: 'github'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                    bat "docker build -t ${DOCKER_IMAGE}:${env.BUILD_NUMBER} ."
                    echo "Docker image built"
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "Logging into Docker Hub"
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        bat "echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin"
                    }
                    echo "Pushing image: ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                    bat "docker push ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                    echo "Pushing image: ${DOCKER_IMAGE}:latest"
                    bat "docker tag ${DOCKER_IMAGE}:${env.BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
                    bat "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
        stage('Deploy to Minikube') {
            steps {
                script {
                    try {
                        echo "Starting Minikube"
                        bat 'minikube start --driver=docker || exit 0'
                        echo "Applying Kubernetes manifests"
                        bat "kubectl apply -f deployment.yaml --kubeconfig=%KUBECONFIG%"
                        echo "Exposing service"
                        bat "minikube service mitra-techday-website-service --url > service-url.txt"
                        echo "Service URL:"
                        bat "type service-url.txt"
                    } catch (Exception e) {
                        echo "Deployment failed: ${e}"
                        throw e
                    }
                }
            }
        }
    }
    post {
        always {
            node('') { // Ensure cleanWs runs in a node context
                cleanWs()
            }
        }
    }
}