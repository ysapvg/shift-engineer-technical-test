pipeline {
    agent any

    environment {
        IMAGE = 'go-service'
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
            docker build \
              --target builder \
              -t go-service-test .

            docker run --rm \
              go-service-test \
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
                sh '''
            docker rm -f go-service || true

            docker run -d \
              --name go-service \
              -p 8080:8080 \
              ${IMAGE}:${VERSION}

            sleep 2

            curl http://host.docker.internal:8080
        '''
            }
        }
    }
}
