pipeline {
    agent any

    environment {
        IMAGE = "go-service"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh '''
                    docker run --rm \
                      -v "$PWD:/app" \
                      -w /app \
                      golang:1.27-alpine \
                      go test ./...
                '''
            }
        }

        stage('Build Image') {
            steps {
                script {
                    env.VERSION = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()

                    sh """
                        docker build \
                        --build-arg VERSION=${VERSION} \
                        -t ${IMAGE}:${VERSION} .
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    echo "Deploying ${IMAGE}:${VERSION}"
                """
            }
        }
    }
}