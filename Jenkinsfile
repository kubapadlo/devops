pipeline {
    agent any

    environment {
        IMAGE_NAME = "kanye-counter-local"
        VERSION    = "1.0.${BUILD_NUMBER}"  // Wbudowana zmienna
    }

    stages {
        stage('Clone') {
            steps {
                checkout scm
                sh 'git clean -fdx' 
            }
        }

        stage('Build & Test') {
            steps {
                sh """
                    docker build \
                    --build-arg GIT_COMMIT=\$(git rev-parse --short HEAD) \
                    --build-arg BUILD_NUMBER=${BUILD_NUMBER} \
                    --build-arg BUILD_DATE=\$(date -u +%Y-%m-%dT%H:%M:%SZ) \
                    -t ${IMAGE_NAME} .
                """
            }
        }

        stage('Publish (Local)') {
            steps {
                sh "docker tag ${IMAGE_NAME} ${IMAGE_NAME}:${VERSION}"
                sh "docker tag ${IMAGE_NAME} ${IMAGE_NAME}:latest"
                echo "Obraz otagowany jako ${IMAGE_NAME}:${VERSION} i :latest"
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // W DinD zawsze używaj localhost dla testów lokalnych po mapowaniu portów
                    def testTarget = "127.0.0.1" 
                    
                    sh "docker rm -f kanye-web-container || true"
                    
                    // Uruchomienie z jawnym mapowaniem portów
                    sh "docker run -d --name kanye-web-container -p 3000:3000 ${IMAGE_NAME}:${VERSION}"
                    
                    echo "DinD Smoke Test: sprawdzam dostępność na http://${testTarget}:3000"
                    
                    // Czekamy na gotowość Next.js (5s to czasem mało dla cięższych apek, zostawiam 7s)
                    sh """
                        sleep 7
                        curl -sSf http://${testTarget}:3000 > /dev/null || (
                            echo 'critical: Smoke test FAILED - logi kontenera:' && 
                            docker logs kanye-web-container && 
                            exit 1
                        )
                    """
                    
                    echo "Sukces! Kontener działa poprawnie wewnątrz DinD."
                }
            }
        }
    }
    post {
        always {
            script {
                sh "docker inspect ${IMAGE_NAME}:${VERSION} > docker-inspect-${VERSION}.json || true"
            }
            archiveArtifacts artifacts: "docker-inspect-${VERSION}.json", allowEmptyArchive: true
        }
    }
}