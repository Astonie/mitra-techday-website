pipeline {
    agent { label 'docker' }

    environment {
        IMAGE_NAME = "mitra-techday:latest"
        GITHUB_REPO = "https://github.com/Astonie/mitra-techday-website.git"
        DEPLOYMENT_NAME = "mitra-techday-deployment"
        SERVICE_NAME = "mitra-techday-service"
        K8S_MANIFEST_PATH = "deployment.yaml"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
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
