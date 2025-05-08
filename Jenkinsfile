pipeline {
    agent any

    environment {
        IMAGE_NAME = "mitra-techday:latest"
        CONTAINER_NAME = "mitra-techday"
        GITHUB_REPO = "https://github.com/Astonie/mitra-techday-website.git"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // This ensures that the Git repository is cloned first
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

        stage('Stop Old Container') {
            steps {
                script {
                    sh "docker rm -f ${CONTAINER_NAME} || echo 'No container to remove'"
                }
            }
        }

        stage('Run New Container') {
            steps {
                script {
                    sh "docker run -d --name ${CONTAINER_NAME} -p 8081:80 ${IMAGE_NAME}"
                }
            }
        }
    }
}
