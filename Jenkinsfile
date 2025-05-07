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
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "Logging into Docker Hub"
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        echo "Pushing image ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                        docker.image("${DOCKER_IMAGE}:${env.BUILD_NUMBER}").push()
                        docker.image("${DOCKER_IMAGE}:${env.BUILD_NUMBER}").push('latest')
                    }
                }
            }
        }
        stage('Deploy to Minikube') {
            steps {
                script {
                    try {
                        // Ensure Minikube is running on the host
                        bat 'minikube start --driver=docker || exit 0'
                        // Apply Kubernetes manifests
                        bat "kubectl apply -f deployment.yaml --kubeconfig=%KUBECONFIG%"
                        // Expose the service and capture URL
                        bat "minikube service mitra-techday-website-service --url > service-url.txt"
                        // Display the service URL
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