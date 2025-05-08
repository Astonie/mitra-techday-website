pipeline {
    agent any

    environment {
        IMAGE_NAME = "mitra-techday:latest"
        CONTAINER_NAME = "mitra-techday"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo "🔨 Building Docker image..."
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Stop Old Container') {
            steps {
                echo "🧹 Stopping old container (if running)..."
                sh "docker rm -f ${CONTAINER_NAME} || echo 'No container to remove'"
            }
        }

        stage('Run New Container') {
            steps {
                echo "🚀 Running new container..."
                sh "docker run -d --name ${CONTAINER_NAME} -p 8081:80 ${IMAGE_NAME}"
            }
        }
    }
}
