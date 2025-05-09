pipeline {
    agent any

    environment {
        IMAGE_NAME = "mitra-techday:latest"
        GITHUB_REPO = "https://github.com/Astonie/mitra-techday-website.git"
        DEPLOYMENT_NAME = "mitra-techday-deployment"
        SERVICE_NAME = "mitra-techday-service"
        K8S_MANIFEST_PATH = "k8s/deployment.yaml" 
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // Ensure Git repo is cloned
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'eval $(minikube docker-env)'
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Apply K8s deployment and service from manifest
                    sh "kubectl apply -f ${K8S_MANIFEST_PATH}"
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    sh "kubectl rollout status deployment/${DEPLOYMENT_NAME}"
                    sh "kubectl get pods"
                    sh "minikube service ${SERVICE_NAME} --url"
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
        }
        success {
            echo 'Deployed successfully to Minikube!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
