pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') // Docker Hub credentials ID
        DOCKER_IMAGE = "mukiwa/mitra-techday-website:latest"
        GIT_REPO = 'https://github.com/Astonie/mitra-techday-website.git'
        KUBECONFIG = '/var/jenkins_home/.kube/config'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("${DOCKER_IMAGE}:${env.BUILD_NUMBER}").push()
                        docker.image("${DOCKER_IMAGE}:${env.BUILD_NUMBER}").push('latest')
                    }
                }
            }
        }
        stage('Deploy to Minikube') {
            steps {
                script {
                    // Ensure Minikube is running on the host
                    bat 'minikube start --driver=docker'
                    // Apply Kubernetes manifests
                    bat "kubectl apply -f deployment.yaml --kubeconfig=%USERPROFILE%\\.kube\\config"
                    // Expose the service
                    bat "minikube service mitra-techday-website-service --url"
                }
            }
        }
    }
    post {
        always {
            cleanWs() // Clean workspace after pipeline execution
        }
    }
}