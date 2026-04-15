pipeline {
    agent any

    environment {
        IMAGE_NAME = "kanye-counter-local"
    }

    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Publish (Local)') {
            steps {
                sh "docker tag ${IMAGE_NAME} ${IMAGE_NAME}:latest"
                echo "Obraz został zbudowany i przetestowany lokalnie."
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh "docker rm -f kanye-web-container || true"
                    sh "docker run -d --name kanye-web-container -p 3000:3000 ${IMAGE_NAME}"
                }
                echo "Aplikacja dostępna pod adresem http://localhost:3000"
            }
        }
    }
}