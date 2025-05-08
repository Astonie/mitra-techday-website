pipeline {
    agent any

    environment {
        IMAGE_NAME = "mitra-techday:latest"
        CONTAINER_NAME = "mitra-techday"
        GITHUB_REPO = "https://github.com/Astonie/mitra-techday-website.git"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git credentialsId: 'github-creds', url: "${GITHUB_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Stop Old Container') {
            steps {
                script {
                    bat "docker rm -f ${CONTAINER_NAME} || echo 'No container to remove'"
                }
            }
        }

        stage('Run New Container') {
            steps {
                script {
                    bat "docker run -d --name ${CONTAINER_NAME} -p 8081:80 ${IMAGE_NAME}"
                }
            }
        }
    }
}
